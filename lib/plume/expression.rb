# frozen_string_literal: true

module Plume
	class Parser
		# lower == less == last
		# sqlite> select not 0 + 1;
		# 0
		# sqlite> select not (0 + 1);
		# 0
		# sqlite> select (not 0) + 1;
		# 2
		OPERATOR_PRECEDENCE = {
			TILDE:   100,
			UPLUS:   100,
			UMINUS:  100,
			COLLATE:  90,
			CONCAT:   80,
			PTR:      80,
			PTR2:     80,
			STAR:     70,
			SLASH:    70,
			REM:      70,
			PLUS:     60,
			MINUS:    60,
			BITAND:   55,
			BITOR:    55,
			LSHIFT:   55,
			RSHIFT:   55,
			ESCAPE:   52,
			NOT:      50,
			LT:       40,
			GT:       40,
			LE:       40,
			GE:       40,
			EQ:       30,
			NE:       30,
			IS:       30,
			BETWEEN:  20,
			IN:       20,
			MATCH:    20,
			LIKE:     20,
			REGEXP:   20,
			GLOB:     20,
			AND:      10,
			OR:        5,
		}.freeze

		TOKEN_TO_OPERATOR = {
			CONCAT: :CONCAT,
			PTR1:   :EXTRACT,
			PTR2:   :RETRIEVE,
			STAR:   :MULTIPLY,
			SLASH:  :DIVIDE,
			REM:    :MODULO,
			PLUS:   :ADD,
			MINUS:  :SUB,
			BITAND: :BIT_AND,
			BITOR:  :BIT_OR,
			LSHIFT: :BIT_LSHIFT,
			RSHIFT: :BIT_RSHIFT,
			LT:     :BELOW,
			GT:     :ABOVE,
			LE:     :ATMOST,
			GE:     :ATLEAST,
			EQ:     :EQUALS,
			NE:     :NOT_EQUALS,
			IS:     :IS
		}.freeze

		def expression(min_precedence = 0)
			# ◯┬─▶[ literal-value ]───────────────────────────────────────────────────────────────────────────────────┬─▶◯
			#  ├─▶{ bind-parameter }────────────────────────────────────────────────────────────────────────────────▶─┤
			#  ├────────────────────────┬──────────────────────┐                                                      │
			#  ├─▶{ schema-name }─▶{ . }┴▶{ table-name }─▶{ . }┴▶{ column-name }────────────────────────────────────▶─┤
			#  ├─▶{ unary-operator }─▶[ expr ]──────────────────────────────────────────────────────────────────────▶─┤
			#  ├─▶[ expr ]─▶{ binary-operator }─▶[ expr ]───────────────────────────────────────────────────────────▶─┤
			#  ├─▶{ function-name }─▶{ ( }─▶[ function-arguments ]─▶{ ) }┬───────────────────┬┬─────────────────────▶─┤
			#  │       ┌──{ , }◀─┐                                       └▶[ filter-clause ]─┘└▶[ over-clause ]─────▶─┤
			#  ├─▶{ ( }┴▶[ expr ]┴▶{ ) }────────────────────────────────────────────────────────────────────────────▶─┤
			#  ├─▶{ CAST }─▶{ ( }─▶[ expr ]─▶{ AS }─▶[ type-name ]─▶{ ) }───────────────────────────────────────────▶─┤
			#  ├─▶[ expr ]─▶{ COLLATE }─▶{ collation-name }─────────────────────────────────────────────────────────▶─┤
			#  ├─▶[ expr ]┬▶{ NOT }┬┬▶{ LIKE }─────▶[ expr ]─┬────▶────────────────┬▶┬──────────────────────────────▶─┤
			#  │          └────▶───┘├▶{ GLOB }───┐           └▶{ ESCAPE }─▶[ expr ]┘ │                                │
			#  │                    ├▶{ REGEXP }─┼─▶[ expr ]────────────▶────────────┘                                │
			#  │                    └▶{ MATCH }──┘                                                                    │
			#  ├─▶[ expr ]┬▶{ ISNULL }───────┬──────────────────────────────────────────────────────────────────────▶─┤
			#  │          ├▶{ NOTNULL }──────┤                                                                        │
			#  │          └▶{ NOT }─▶{ NULL }┘                                                                        │
			#  ├─▶[ expr ]─▶{ IS }┬▶{ NOT }┬┬▶{ DISTINCT }─▶{ FROM }┬▶[ expr ]──────────────────────────────────────▶─┤
			#  │                  └────▶───┘└────────────▶──────────┘                                                 │
			#  ├─▶[ expr ]┬▶{ NOT }┬▶{ BETWEEN }─▶[ expr ]─▶{ AND }─▶[ expr ]───────────────────────────────────────▶─┤
			#  │          └────▶───┘               ┌─────────────────┐                                                │
			#  ├─▶[ expr ]┬▶{ NOT }┬▶{ IN }┬▶{ ( }─┼▶[ select-stmt ]─┼▶{ ) }────────────────────────────────────────▶─┤
			#  │          └────▶───┘       │       └─┬──▶[ expr ]──┬─┘                                                │
			#  │                           │         └────{ , }◀───┘ ┌▶{ table-name }───────────────────────────────▶─┤
			#  │                           ├────────────────────────┐│                           ┌──{ , }──┐          │
			#  │                           └─▶{ schema-name }─▶{ . }┴┴▶{ table-function }─▶{ ( }┬┴▶[ expr ]┴┬▶{ ) }─▶─┤
			#  ├────▶────┬───────────┐                                                          └─────▶─────┘         │
			#  ├─▶{ NOT }┴▶{ EXISTS }┴▶{ ( }─▶[ select-stmt ]─▶{ ) }────────────────────────────────────────────────▶─┤
			#  ├─▶{ CASE }┬▶[ expr ]┬┬▶{ WHEN }─▶[ expr ]─▶{ THEN }─▶[ expr ]┬┬▶{ ELSE }─▶[ expr ]┬▶{ END }─────────▶─┤
			#  │          └─────▶───┘└────────────────◀──────────────────────┘└─────────▶─────────┘                   │
			#  └─▶[ raise-function ]────────────────────────────────────────────────────────────────────────────────▶─┘

			left = basic_expression

			while (op = current_token)
				op_precedence = OPERATOR_PRECEDENCE[op] || -1
				break if op_precedence < min_precedence

				require op

				case op
				when :BETWEEN
					middle = expression(op_precedence + 1)
					require :AND
					right = expression(op_precedence + 1)
					left = BetweenExpression.new(
						left: left,
						middle: middle,
						right: right
					)
				when :IN
					# right = expression(op_precedence + 1)
					# left = { op => [left, right] }
					if maybe :LP
						if maybe :RP
							{ lexpr => { IN: [] } }
						# elsif (s = optional { select_stmt })
						# 	require :RP

						# 	{ lexpr => { IN: s } }
						elsif (e = optional { expr })
							exprs = one_or_more(given: e) { expr }
							require :RP
							left = { left => { op => exprs } }
						else
							error!(current_token, current_value, [:RP, "select-stmt", "expr"])
						end
					elsif :ID == current_token
						ref = table_ref

						if maybe :LP
							if maybe :RP
								{ lexpr => { IN: { FN: { ref => [] } } } }
							elsif (e = optional { expr })
								expr = one_or_more(given: e) { expr }
								require :RP
								{ lexpr => { IN: { FN: { ref => exprs } } } }
							else
								error!(current_token, current_value, [:RP, "expr"])
							end
						else
							{ lexpr => { IN: ref } }
						end
					else
						error!(current_token, current_value, [:LP, :ID])
					end
				when :LIKE, :GLOB, :REGEXP, :MATCH
					right = expression(op_precedence + 1)
					left = { op => [left, right] }
				else
					right = expression(op_precedence + 1)

					left = BinaryExpression.new(
						operator: TOKEN_TO_OPERATOR[op],
						left:,
						right:,
					)
				end
			end

			left
		end

		def basic_expression
			if maybe :TILDE
				{ BITWISE_NOT: expression(OPERATOR_PRECEDENCE[:TILDE]) }
			elsif maybe :PLUS
				expression(:UPLUS)
			elsif maybe :MINUS
				UnaryExpression.new(
					operator: :NEGATE,
					operand: expression(OPERATOR_PRECEDENCE[:UMINUS])
				)
			elsif maybe :LP
				e = expression(0)
				require :RP
				e
			elsif :ID == current_token
				Identifier.new(value: identifier)
			elsif (v = optional { literal_value })
				v
			elsif maybe :NOT
				UnaryExpression.new(
					operator: :NOT,
					operand: expression(OPERATOR_PRECEDENCE[:NOT])
				)
			elsif maybe :CAST
				require :LP
				e = expression
				require :AS
				t = type_name
				require :RP
				{ CAST: [e, t] }
				# ... other primary expressions ...
			else
				raise "Expected primary expression: #{current_token}[#{current_value}]"
			end
		end
	end
end
