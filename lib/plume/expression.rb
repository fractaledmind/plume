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

				negated = maybe :NOT

				if maybe :IN
					expression_node = negated ? NotInExpression : InExpression

					if maybe :LP
						if maybe :RP
							left = expression_node.new(
								member: left,
								collection: []
							)
							# elsif (s = optional { select_stmt })
							# 	require :RP

							# 	{ lexpr => { IN: s } }
						elsif (e = optional { expression(op_precedence + 1) })
							exprs = one_or_more(given: e) { expression(op_precedence + 1) }
							require :RP

							left = expression_node.new(
								member: left,
								collection: exprs
							)
						else
							expected!(:RP, "select-stmt", "expr")
						end
					elsif (ref = optional { identifier })
						if maybe :DOT
							schema_name = ref
							name = identifier

							if maybe :LP
								function_name = name
								arguments = zero_or_more { expression(op_precedence + 1) }
								require :RP

								collection = FunctionReference.new(
									schema_name:,
									function_name:,
									arguments:,
								)
							else
								table_name = name

								collection = TableReference.new(
									schema_name:,
									table_name:,
								)
							end
						elsif maybe :LP
							function_name = ref
							arguments = zero_or_more { expression(op_precedence + 1) }
							require :RP

							collection = FunctionReference.new(
								function_name:,
								arguments:,
							)
						else
							table_name = ref

							collection = TableReference.new(
								table_name:,
							)
						end

						left = expression_node.new(
							member: left,
							collection:
						)
					else
						expected!(:LP, :ID)
					end
				elsif maybe :BETWEEN
					middle = expression(op_precedence + 1)
					require :AND
					right = expression(op_precedence + 1)
					left = TernaryExpression.new(
						operator: (negated ? :NOT_BETWEEN : :BETWEEN),
						left: left,
						middle: middle,
						right: right
					)
				elsif maybe :LIKE
					# like_expression(negated:, op_precedence:)
				elsif either :GLOB, :REGEXP, :MATCH
					# matching_expression(negated:, op_precedence:)
				end

				# error if not

				# require op

				# case op
				# when :BETWEEN
				# 	middle = expression(op_precedence + 1)
				# 	require :AND
				# 	right = expression(op_precedence + 1)
				# 	left = TernaryExpression.new(
				# 		operator: :BETWEEN,
				# 		left: left,
				# 		middle: middle,
				# 		right: right
				# 	)
				# when :IN
				# 	in_expression(not: false)
				# when :NOT
				# 	require :NOT
				# 	case (op = current_token)
				# 		when :IN then in_expression(not: true)
				# 	end
				# when :LIKE
				# 	right = expression(op_precedence + 1)
				# 	escape = maybe(:ESCAPE) ? expression : nil
				# 	left = LikeExpression.new(
				# 		left:,
				# 		right:,
				# 		escape:,
				# 	)
				# when :LIKE, :GLOB, :REGEXP, :MATCH
				# 	right = expression(op_precedence + 1)
				# 	left = { op => [left, right] }
				# else
				# 	right = expression(op_precedence + 1)

				# 	left = BinaryExpression.new(
				# 		operator: TOKEN_TO_OPERATOR[op],
				# 		left:,
				# 		right:,
				# 	)
				# end
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
				expected!
			end
		end
	end
end
