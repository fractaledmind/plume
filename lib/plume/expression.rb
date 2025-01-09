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
			TILDE: 100,
			UPLUS: 100,
			UMINUS: 100,
			COLLATE: 90,
			CONCAT: 80,
			PTR: 80,
			PTR2: 80,
			STAR: 70,
			SLASH: 70,
			REM: 70,
			PLUS: 60,
			MINUS: 60,
			BITAND: 55,
			BITOR: 55,
			LSHIFT: 55,
			RSHIFT: 55,
			ESCAPE: 52,
			NOT: 50,
			LT: 40,
			GT: 40,
			LE: 40,
			GE: 40,
			EQ: 30,
			NE: 30,
			IS: 30,
			BETWEEN: 20,
			IN: 20,
			MATCH: 20,
			LIKE: 20,
			REGEXP: 20,
			GLOB: 20,
			AND: 10,
			OR: 5,
		}.freeze

		def Expression
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

			expression
		end

		def expression(min_precedence = 0)
			lhs = basic_expression
			while (op = current_token)
				op_precedence = OPERATOR_PRECEDENCE[op] || -1
				break if op_precedence < min_precedence

				accept op

				case op
				when :BETWEEN
					middle = expression(op_precedence + 1)
					accept :AND
					right = expression(op_precedence + 1)
					lhs = { BETWEEN: [lhs, middle, right] }
				when :IN
					# rhs = expression(op_precedence + 1)
					# lhs = { op => [lhs, rhs] }
					if maybe :LP
						if maybe :RP
							{ lexpr => { IN: [] } }
						# elsif (s = optional { select_stmt })
						# 	accept :RP

						# 	{ lexpr => { IN: s } }
						elsif (e = optional { expr })
							exprs = one_or_more(given: e) { expr }
							accept :RP
							lhs = { lhs => { op => exprs } }
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
								accept :RP
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
					rhs = expression(op_precedence + 1)
					lhs = { op => [lhs, rhs] }
				else
					rhs = expression(op_precedence + 1)
					lhs = { op => [lhs, rhs] }
				end
			end

			lhs
		end

		def basic_expression
			if maybe :TILDE
				{ BITWISE_NOT: expression(OPERATOR_PRECEDENCE[:TILDE]) }
			elsif maybe :PLUS
				expression(:UPLUS)
			elsif maybe :MINUS
				{ NEGATE: expression(OPERATOR_PRECEDENCE[:UMINUS]) }
			elsif maybe :LP
				e = expression(0)
				accept :RP
				e
			elsif :ID == current_token
				identifier
			elsif (v = optional { literal_value })
				v
			elsif maybe :NOT
				{ NOT: expression(OPERATOR_PRECEDENCE[:NOT]) } # Precedence of NOT
			elsif maybe :CAST
				accept :LP
				e = expression()
				accept :AS
				t = type_name
				accept :RP
			{ CAST: [e, t] }
				# ... other primary expressions ...
			else
				raise "Expected primary expression: #{current_token}[#{current_value}]"
			end
		end
	end
end