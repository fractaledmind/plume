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
			BITNOT:  100,
			UPLUS:   100,
			UMINUS:  100,
			COLLATE:  90,
			CONCAT:   80,
			PTR1:     80,
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
			NOT:      50,
			LT:       40,
			GT:       40,
			LE:       40,
			GE:       40,
			EQ:       30,
			NE:       30,
			IS:       30,
			ISNULL:   30,
			NOTNULL:  30,
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
			AND:       :ALL,
			OR:        :ANY,
			CONCAT:    :CONCAT,
			PTR1:      :EXTRACT,
			PTR2:      :RETRIEVE,
			STAR:      :MULTIPLY,
			SLASH:     :DIVIDE,
			REM:       :MODULO,
			PLUS:      :ADD,
			MINUS:     :SUB,
			BITAND:    :BIT_AND,
			BITOR:     :BIT_OR,
			LSHIFT:    :BIT_LSHIFT,
			RSHIFT:    :BIT_RSHIFT,
			LT:        :BELOW,
			GT:        :ABOVE,
			LE:        :ATMOST,
			GE:        :ATLEAST,
			EQ:        :EQUALS,
			NE:        :NOT_EQUALS,
			IS:        :IS,
			ISNOT:     :IS_NOT,
			GLOB:      :GLOB,
			REGEXP:    :REGEXP,
			MATCH:     :MATCH,
			NOTGLOB:   :NOT_GLOB,
			NOTREGEXP: :NOT_REGEXP,
			NOTMATCH:  :NOT_MATCH,
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
							return expression_node.new(
								member: left,
								collection: []
							)
						# :nocov:
						elsif (s = optional { select_stmt })
							require :RP

							return expression_node.new(
								member: left,
								collection: s
							)
							# :nocov:
						elsif (e = optional { expression(op_precedence + 1) })
							exprs = one_or_more(given: e) { expression(op_precedence + 1) }
							require :RP

							return expression_node.new(
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
									arguments: FunctionArguments.new(
										expressions: arguments
									),
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
								arguments: FunctionArguments.new(
									expressions: arguments
								),
							)
						else
							table_name = ref

							collection = TableReference.new(
								table_name:,
							)
						end

						return expression_node.new(
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
					return TernaryExpression.new(
						operator: (negated ? :NOT_BETWEEN : :BETWEEN),
						left: left,
						middle: middle,
						right: right
					)
				elsif maybe :LIKE
					expression_node = negated ? NotLikeExpression : LikeExpression
					right = expression(op_precedence + 1)
					escape = maybe(:ESCAPE) ? expression : nil
					return expression_node.new(
						left:,
						right:,
						escape:,
					)
				elsif (mop = either :GLOB, :REGEXP, :MATCH, nil)
					op = negated ? :"NOT#{mop}" : mop
					right = expression(op_precedence + 1)
					return BinaryExpression.new(
						operator: TOKEN_TO_OPERATOR[op],
						left:,
						right:,
					)
				end

				expected!(:IN, :BETWEEN, :LIKE, :GLOB, :REGEXP, :MATCH) if negated

				if maybe :ISNULL
					left = UnaryExpression.new(
						operator: :IS_NULL,
						operand: left
					)
				elsif maybe :NOTNULL
					left = UnaryExpression.new(
						operator: :NOT_NULL,
						operand: left
					)
				elsif maybe :IS
					negated = maybe :NOT
					op = :"#{op}NOT" if negated
					maybe_all :DISTINCT, :FROM
					right = expression(op_precedence + 1)
					left = BinaryExpression.new(
						operator: TOKEN_TO_OPERATOR[op],
						left:,
						right:,
					)
				elsif maybe :COLLATE
					left = CollationExpression.new(
						expression: left,
						collation_name: identifier.to_sym.upcase
					)
				else
					require op
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
			if maybe :BITNOT
				UnaryExpression.new(
					operator: :INVERT,
					operand: expression(OPERATOR_PRECEDENCE[:BITNOT])
				)
			elsif maybe :PLUS
				UnaryExpression.new(
					operator: :IDENTITY,
					operand: expression(OPERATOR_PRECEDENCE[:UPLUS])
				)
			elsif maybe :MINUS
				UnaryExpression.new(
					operator: :NEGATE,
					operand: expression(OPERATOR_PRECEDENCE[:UMINUS])
				)
			elsif maybe :LP
				# could be implicit EXISTS expression
				e = expression(0)
				require :RP
				e
			elsif maybe :NOT
				# could be NOT EXISTS expression
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

				CastExpression.new(
					expression: e,
					as: t,
				)
			elsif maybe :CASE
				if maybe :WHEN
					conditions = one_or_more(sep: :WHEN) do
						case_predicate = expression
						require :THEN
						case_consequence = expression

						CaseCondition.new(
							predicate: case_predicate,
							consequence: case_consequence,
						)
					end
					else_clause = maybe(:ELSE) ? expression : nil
					require :END

					CaseExpression.new(
						predicate: nil,
						conditions:,
						else_clause:,
					)
				else
					predicate = expression
					require :WHEN
					conditions = one_or_more(sep: :WHEN) do
						case_predicate = expression
						require :THEN
						case_consequence = expression

						CaseCondition.new(
							predicate: case_predicate,
							consequence: case_consequence,
						)
					end
					else_clause = maybe(:ELSE) ? expression : nil
					require :END

					CaseExpression.new(
						predicate:,
						conditions:,
						else_clause:,
					)
				end
			elsif maybe :EXISTS
				# is EXISTS expression
			elsif (v = optional { literal_value })
				case v
				when LiteralNil then nil
				when LiteralFalse then false
				else v
				end
			elsif :ID == current_token
				case peek(2)
				in [:IN, :LP]
					ColumnReference.new(
						column_name: identifier,
					)
				in [:LP, _]
					function_name = identifier.to_sym.upcase
					require :LP
					arguments = function_arguments
					require :RP
					filter = optional { filter_clause }
					over = optional { over_clause }

					FunctionReference.new(
						function_name:,
						arguments:,
						filter_clause: filter,
						over_clause: over,
					)
				in [:DOT, _]
					schema_or_table_name = identifier
					require :DOT
					table_or_column_name = identifier
					if maybe :DOT
						column_name = identifier
						ColumnReference.new(
							schema_name: schema_or_table_name,
							table_name: table_or_column_name,
							column_name:,
						)
					else
						ColumnReference.new(
							table_name: schema_or_table_name,
							column_name: table_or_column_name,
						)
					end
				else
					ColumnReference.new(
						column_name: identifier,
					)
				end
			elsif :RAISE == current_token
				left = raise_function
			else
				expected!(".............")
			end
		end

		def raise_function
			# ◯─▶{ RAISE }─▶{ ( }┬─▶{ IGNORE }────────────────────▶─────────┬▶{ ) }──▶◯
			#                    ├─▶{ ROLLBACK }─┬▶{ , }─▶{ error-message }─┘
			#                    ├─▶{ ABORT }──▶─┤
			#                    └─▶{ FAIL }───▶─┘
			require_all :RAISE, :LP
			if maybe :IGNORE
				require :RP
				RaiseExpression.new(type: :IGNORE)
			elsif maybe :ROLLBACK
				require :COMMA
				error_message = identifier
				require :RP
				RaiseExpression.new(type: :ROLLBACK, message: error_message)
			elsif maybe :ABORT
				require :COMMA
				error_message = identifier
				require :RP
				RaiseExpression.new(type: :ABORT, message: error_message)
			elsif maybe :FAIL
				require :COMMA
				error_message = identifier
				require :RP
				RaiseExpression.new(type: :FAIL, message: error_message)
			else
				expected!(:IGNORE, :ROLLBACK, :ABORT, :FAIL)
			end
		end

		def function_arguments
			#     ┌─▶{ DISTINCT }─▶┐ ┌──{ , }◀─┐
			# ◯─▶─┼────────────────┴▶┴▶[ expr ]┼───────────┬─┬─▶◯
			#     │ ┌──────────────────────────┘           │ │
			#     │ └▶{ ORDER }─▶{ BY }┬▶[ ordering-term ]─┤ │
			#     │                    └───────{ , }◀──────┘ │
			#     └─────────────────┬▶{ * }┬▶────────────────┘
			#                       └───▶──┘
			if maybe :DISTINCT
				distinct = true
				expressions = one_or_more { expr }
				order_by = maybe_all(:ORDER, :BY) ? one_or_more { ordering_term } : nil

				FunctionArguments.new(
					distinct:,
					expressions:,
					order_by:,
				)
			elsif maybe :STAR
				StarFunctionArgument.new
			elsif (e = optional { expr })
				expressions = one_or_more(given: e) { expr }
				order_by = maybe_all(:ORDER, :BY) ? one_or_more { ordering_term } : nil

				FunctionArguments.new(
					expressions:,
					order_by:,
				)
			elsif :RP == current_token
				EmptyFunctionArgument.new
			else
				expected!(:DISTINCT, :STAR, :RP, "expr")
			end
		end

		def filter_clause
			# ◯─▶{ FILTER }─▶{ ( }─▶{ WHERE }─▶[ expr ]─▶{ ) }─▶◯
			require_all :FILTER, :LP, :WHERE
			condition = expr
			require :RP

			condition
		end

		def over_clause
			# ◯─▶{ OVER }┬─▶{ window-name }───────────────────────────────┬─▶◯
			#            └─▶{ ( }┬───────────▶────────────┐               │
			#                    └─▶{ base-window-name }─▶┤               │
			#                 ┌───────────────◀───────────┘               │
			#                 ├─▶{ PARTITION }─▶{ BY }┬[ expr ]┐          │
			#                 │                       └─{ , }◀─┤          │
			#                 ├────────────◀───────────────────┘          │
			#                 ├─▶{ ORDER }─▶{ BY }┬[ ordering-term ]┐     │
			#                 │                   └──────{ , }◀─────┤     │
			#                 ├─────────────◀───────────────────────┘     │
			#                 ├─▶[ frame-spec ]┬─▶──────────────────{ ) }─┘
			#                 └─────────▶──────┘
			require :OVER
			if maybe :LP
				baseless_window = optional do
					partition_by = maybe_all(:PARTITION, :BY) ? one_or_more { expr } : nil
					order_by = maybe_all(:ORDER, :BY) ? one_or_more { ordering_term } : nil
					frame = one_of?(:RANGE, :ROWS, :GROUPS) ? frame_spec : nil
					require :RP

					OverClause.new(
						partition_by:,
						order_by:,
						frame:,
					)
				end
				return baseless_window if baseless_window

				base_window_name = optional { identifier }
				order_by = maybe_all(:ORDER, :BY) ? one_or_more { ordering_term } : nil
				frame = one_of?(:RANGE, :ROWS, :GROUPS) ? frame_spec : nil
				require :RP

				OverClause.new(
					base_window_name:,
					order_by:,
					frame:,
				)
			else
				OverClause.new(window_name: identifier)
			end
		end

		def frame_spec
			# ◯┬─▶{ RANGE }──┬┬▶{ BETWEEN }┬─▶{ UNBOUNDED }─▶{ PRECEDING }┬▶{ AND }┬─▶[ expr ]─▶{ PRECEDING }────▶─┐
			#  ├─▶{ ROWS }───┤│            ├─▶[ expr ]─▶{ PRECEDING }─────┤        ├─▶{ CURRENT }─▶{ ROW }───────▶─┤
			#  └─▶{ GROUPS }─┘│            ├─▶{ CURRENT }─▶{ ROW }────────┤        ├─▶[ expr ]─▶{ FOLLOWING }────▶─┤
			#                 │            └─▶[ expr ]─▶{ FOLLOWING }─────┘        └─▶{ UNBOUNDED }─▶{ FOLLOWING }─┤
			#                 ├─▶{ UNBOUNDED }─▶{ PRECEDING }────────────────────────────────────────────────────▶─┤
			#                 ├─▶[ expr ]─▶{ PRECEDING }─────────────────────────────────────────────────────────▶─┤
			#                 └─▶{ CURRENT }─▶{ ROW }────────────────────────────────────────────────────────────▶─┤
			#                                         ┌────────────────────────────────────────────────────────────┘
			#                                         ├─▶{ EXCLUDE }─▶{ NO }─▶{ OTHERS }───▶─┐
			#                                         ├─▶{ EXCLUDE }─▶{ CURRENT }─▶{ ROW }─▶─┤
			#                                         ├─▶{ EXCLUDE }─▶{ GROUP }────────────▶─┤
			#                                         ├─▶{ EXCLUDE }─▶{ TIES }─────────────▶─┤
			#                                         └──────────────────────────────────────┴─────────▶◯
			if one_of? :RANGE, :ROWS, :GROUPS
				type = require current_token
				if maybe :BETWEEN
					if maybe_all :UNBOUNDED, :PRECEDING
						precedence = 1
						starting_boundary = FrameBoundary.new(
							type: :PRECEDING,
							value: :UNBOUNDED
						)
					elsif maybe_all :CURRENT, :ROW
						precedence = 3
						starting_boundary = FrameBoundary.new(
							type: :CURRENT_ROW
						)
					elsif (e = optional { expression })
						if maybe :PRECEDING
							precedence = 2
							starting_boundary = FrameBoundary.new(
								type: :PRECEDING,
								value: e
							)
						elsif maybe :FOLLOWING
							precedence = 4
							starting_boundary = FrameBoundary.new(
								type: :FOLLOWING,
								value: e
							)
						else
							expected!(:PRECEDING, :FOLLOWING)
						end
					else
						expected!("UNBOUNDED PRECEDING", "CURRENT ROW", "expr")
					end
					require :AND
					if maybe_all :CURRENT, :ROW
						expected!("UNBOUNDED FOLLOWING", "expr") if 3 < precedence
						ending_boundary = FrameBoundary.new(
							type: :CURRENT_ROW,
						)
					elsif maybe_all :UNBOUNDED, :FOLLOWING
						ending_boundary = FrameBoundary.new(
							type: :FOLLOWING,
							value: :UNBOUNDED
						)
					elsif (e = optional { expr })
						if maybe :PRECEDING
							expected!("CURRENT ROW", "UNBOUNDED FOLLOWING", "expr") if 2 < precedence
							ending_boundary = FrameBoundary.new(
								type: :PRECEDING,
								value: e
							)
						elsif maybe :FOLLOWING
							expected!("UNBOUNDED FOLLOWING") if 4 < precedence
							ending_boundary = FrameBoundary.new(
								type: :FOLLOWING,
								value: e
							)
						else
							expected!(:PRECEDING, :FOLLOWING)
						end
					else
						expected!("CURRENT ROW", "UNBOUNDED FOLLOWING", "expr")
					end
				elsif maybe_all :UNBOUNDED, :PRECEDING
					starting_boundary = FrameBoundary.new(
						type: :PRECEDING,
						value: :UNBOUNDED
					)
					ending_boundary = nil
				elsif maybe_all :CURRENT, :ROW
					starting_boundary = FrameBoundary.new(
						type: :CURRENT_ROW
					)
					ending_boundary = nil
				elsif (e = optional { expr })
					require :PRECEDING
					starting_boundary = FrameBoundary.new(
						type: :PRECEDING,
						value: e
					)
					ending_boundary = nil
				else
					expected!(:BETWEEN, :UNBOUNDED, :CURRENT, "expr")
				end
				exclude = nil
				if maybe :EXCLUDE
					if maybe :GROUP
						exclude = :GROUP
					elsif maybe :TIES
						exclude = :TIES
					elsif maybe_all :NO, :OTHERS
						exclude = :NO_OTHERS
					elsif maybe_all :CURRENT, :ROW
						exclude = :CURRENT_ROW
					else
						expected!(:GROUP, :TIES, "NO OTHERS", "CURRENT ROW")
					end
				end

				FrameSpec.new(
					type:,
					starting_boundary:,
					ending_boundary:,
					exclude:,
				)
			else
				expected!(:RANGE, :ROWS, :GROUPS)
			end
		end
	end
end
