# frozen_string_literal: true

module Plume
	class Parser
		class ErrorMessage
			attr_reader :msg

			def initialize(msg)
				@msg = msg
			end
		end

		# see: https://github.com/sqlite/sqlite/blob/master/src/parse.y#L255-L283
		TOKEN_FALLBACKS = {
			SEMI:						nil,
			EXPLAIN:				:ID,
			QUERY:					:ID,
			PLAN:						:ID,
			BEGIN:					:ID,
			TRANSACTION:		nil,
			DEFERRED:				:ID,
			IMMEDIATE:			:ID,
			EXCLUSIVE:			:ID,
			COMMIT:					nil,
			END:						:ID,
			ROLLBACK:				:ID,
			SAVEPOINT:			:ID,
			RELEASE:				:ID,
			TO:							nil,
			TABLE:					nil,
			CREATE:					nil,
			IF:							:ID,
			NOT:						nil,
			EXISTS:					nil,
			TEMP:						:ID,
			TEMPORARY:			:ID,
			LP:							nil,
			RP:							nil,
			AS:							nil,
			COMMA:					nil,
			WITHOUT:				:ID,
			ABORT:					:ID,
			ACTION:					:ID,
			AFTER:					:ID,
			ANALYZE:				:ID,
			ASC:						:ID,
			ATTACH:					:ID,
			BEFORE:					:ID,
			BY:							:ID,
			CASCADE:				:ID,
			CAST:						:ID,
			CONFLICT:				:ID,
			DATABASE:				:ID,
			DESC:						:ID,
			DETACH:					:ID,
			EACH:						:ID,
			FAIL:						:ID,
			OR:							nil,
			AND:						nil,
			IS:							nil,
			MATCH:					:ID,
			REGEXP:					:ID,
			GLOB:						:ID,
			LIKE:						:ID,
			BETWEEN:				nil,
			IN:							nil,
			ISNULL:					nil,
			NOTNULL:				nil,
			NE:							nil,
			EQ:							nil,
			ROWID:					:ID,
			STRICT:					:ID,
			GT:							nil,
			LE:							nil,
			LT:							nil,
			GE:							nil,
			ESCAPE:					nil,
			ID:							nil,
			COLUMN:					:ID,
			DO:							:ID,
			FOR:						:ID,
			IGNORE:					:ID,
			INITIALLY:			:ID,
			INSTEAD:				:ID,
			NO:							:ID,
			KEY:						:ID,
			OF:							:ID,
			OFFSET:					:ID,
			PRAGMA:					:ID,
			RAISE:					:ID,
			RECURSIVE:			:ID,
			REPLACE:				:ID,
			RESTRICT:				:ID,
			ROW:						:ID,
			ROWS:						:ID,
			TRIGGER:				:ID,
			VACUUM:					:ID,
			VIEW:						:ID,
			VIRTUAL:				:ID,
			WITH:						:ID,
			NULLS:					:ID,
			FIRST:					:ID,
			LAST:						:ID,
			CURRENT:				:ID,
			FOLLOWING:			:ID,
			PARTITION:			:ID,
			PRECEDING:			:ID,
			RANGE:					:ID,
			UNBOUNDED:			:ID,
			EXCLUDE:				:ID,
			GROUPS:					:ID,
			OTHERS:					:ID,
			TIES:						:ID,
			GENERATED:			:ID,
			ALWAYS:					:ID,
			MATERIALIZED:		:ID,
			REINDEX:				:ID,
			RENAME:					:ID,
			CTIME_KW:				:ID,
			ANY:						nil,
			BITAND:					nil,
			BITOR:					nil,
			LSHIFT:					nil,
			RSHIFT:					nil,
			PLUS:						nil,
			MINUS:					nil,
			STAR:						nil,
			SLASH:					nil,
			REM:						nil,
			CONCAT:					nil,
			PTR:						nil,
			COLLATE:				nil,
			BITNOT:					nil,
			ON:							nil,
			INDEXED:				nil,
			STRING:					nil,
			CROSS:					nil,
			FULL:						nil,
			INNER:					nil,
			LEFT:						nil,
			NATURAL:				nil,
			OUTER:					nil,
			RIGHT:					nil,
			CONSTRAINT:			nil,
			DEFAULT:				nil,
			NULL:						nil,
			PRIMARY:				nil,
			UNIQUE:					nil,
			CHECK:					nil,
			REFERENCES:			nil,
			AUTOINCREMENT:	nil,
			INSERT:					nil,
			DELETE:					nil,
			UPDATE:					nil,
			SET:						nil,
			DEFERRABLE:			nil,
			FOREIGN:				nil,
			DROP:						nil,
			UNION:					nil,
			ALL:						nil,
			EXCEPT:					nil,
			INTERSECT:			nil,
			SELECT:					nil,
			VALUES:					nil,
			DISTINCT:				nil,
			DOT:						nil,
			FROM:						nil,
			JOIN:						nil,
			USING:					nil,
			ORDER:					nil,
			GROUP:					nil,
			HAVING:					nil,
			LIMIT:					nil,
			WHERE:					nil,
			RETURNING:			nil,
			INTO:						nil,
			NOTHING:				nil,
			FLOAT:					nil,
			BLOB:						nil,
			INTEGER:				nil,
			VARIABLE:				nil,
			CASE:						nil,
			WHEN:						nil,
			THEN:						nil,
			ELSE:						nil,
			INDEX:					nil,
			ALTER:					nil,
			ADD:						nil,
			WINDOW:					nil,
			OVER:						nil,
			FILTER:					nil,
			AGG_FUNCTION:		nil,
			AGG_COLUMN:			nil,
			TRUEFALSE:			nil,
			ISNOT:					nil,
			FUNCTION:				nil,
			UMINUS:					nil,
			UPLUS:					nil,
			TRUTH:					nil,
			REGISTER:				nil,
			VECTOR:					nil,
			SELECT_COLUMN:	nil,
			IF_NULL_ROW:		nil,
			ASTERISK:				nil,
			SPAN:						nil,
			ERROR:					nil,
			SPACE:					nil,
			ILLEGAL:				nil,
		}

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

		def initialize(sql)
			@lexer = Lexer.new(sql, skip_spaces: true)
			@peek_buffer = []
		end

		def parse
			result = catch(:ERROR) { sql_stmt_list }

			if ErrorMessage === result
				raise SyntaxError.new(result.msg)
			else
				result
			end
		end

		# private

		def sql_stmt_list
			#   ┌──────{ ; }◀─────┐
			# ◯─┴┬─▶[ sql-stmt ]─┬┴─▶◯
			#    └───────▶───────┘

			[].tap do |stmts|
				until current_token.nil?
					maybe :SEMI
					stmts << sql_stmt if current_token
					maybe :SEMI
				end
			end
		end

		def sql_stmt
			# ◯─┬─────────────┬▶─────────────────────┬─┬─▶[ alter-table-stmt ]──────────▶─┬─▶◯
			#   └─{ EXPLAIN }─┴─▶{ QUERY }─▶{ PLAN }─┘ ├─▶[ analyze-stmt ]──────────────▶─┤
			#                                          ├─▶[ attach-stmt ]───────────────▶─┤
			#                                          ├─▶[ begin-stmt ]────────────────▶─┤
			#                                          ├─▶[ commit-stmt ]───────────────▶─┤
			#                                          ├─▶[ create-index-stmt ]─────────▶─┤
			#                                          ├─▶[ create-table-stmt ]─────────▶─┤
			#                                          ├─▶[ create-trigger-stmt ]───────▶─┤
			#                                          ├─▶[ create-view-stmt ]──────────▶─┤
			#                                          ├─▶[ create-virtual-table-stmt ]─▶─┤
			#                                          ├─▶[ delete-stmt ]───────────────▶─┤
			#                                          ├─▶[ detach-stmt ]───────────────▶─┤
			#                                          ├─▶[ drop-index-stmt ]───────────▶─┤
			#                                          ├─▶[ drop-table-stmt ]───────────▶─┤
			#                                          ├─▶[ drop-trigger-stmt ]─────────▶─┤
			#                                          ├─▶[ drop-view-stmt ]────────────▶─┤
			#                                          ├─▶[ insert-stmt ]───────────────▶─┤
			#                                          ├─▶[ pragma-stmt ]───────────────▶─┤
			#                                          ├─▶[ reindex-stmt ]──────────────▶─┤
			#                                          ├─▶[ release-stmt ]──────────────▶─┤
			#                                          ├─▶[ rollback-stmt ]─────────────▶─┤
			#                                          ├─▶[ savepoint-stmt ]────────────▶─┤
			#                                          ├─▶[ select-stmt ]───────────────▶─┤
			#                                          ├─▶[ update-stmt ]───────────────▶─┤
			#                                          └─▶[ vacuum-stmt ]───────────────▶─┘

			require :PLAN if (explain = maybe :EXPLAIN) && (query_plan = maybe :QUERY)

			case current_token
			when :ALTER							then alter_table_stmt
			when :ANALYZE						then analyze_stmt
			when :ATTACH						then attach_stmt
			when :BEGIN							then begin_stmt
			when :COMMIT, :END			then commit_stmt
			when :CREATE
				case peek
				when :INDEX		then create_index_stmt
				when :TABLE		then create_table_stmt
				when :TRIGGER	then create_trigger_stmt
				when :VIEW		then create_view_stmt
				when :VIRTUAL	then create_virtual_table_stmt
				when :UNIQUE	then create_index_stmt
				when :TEMP, :TEMPORARY
					case peek(2)
					when [:TEMP, :TABLE]				then create_table_stmt
					when [:TEMP, :TRIGGER]			then create_trigger_stmt
					when [:TEMP, :VIEW]					then create_view_stmt
					when [:TEMPORARY, :TABLE]		then create_table_stmt
					when [:TEMPORARY, :TRIGGER]	then create_trigger_stmt
					when [:TEMPORARY, :VIEW]		then create_view_stmt
					else
						error!(peek(2).last, values(3).last, [:TABLE, :TRIGGER, :VIEW])
					end
				else
					error!(peek, values(2).last, [:INDEX, :TABLE, :TRIGGER, :VIEW, :VIRTUAL, :UNIQUE, :TEMP, :TEMPORARY])
				end
			when :DELETE						then delete_stmt
			when :DETACH						then detach_stmt
			when :DROP
				case peek
				when :INDEX		then drop_index_stmt
				when :TABLE		then drop_table_stmt
				when :TRIGGER	then drop_trigger_stmt
				when :VIEW		then drop_view_stmt
				else
					# TODO: error!()
					# unexpected_token = peek
					# *context, unexpected = values(2)
					# raise SyntaxError, <<~TXT
					# 	Unexpected token after '#{context.join(" ")}': #{unexpected_token}[#{unexpected.inspect}]
					# 	Expected one of: INDEX, TABLE, TRIGGER, VIEW
					# TXT
				end
			when :INSERT, :REPLACE	then insert_stmt
			when :PRAGMA						then pragma_stmt
			when :REINDEX						then reindex_stmt
			when :RELEASE						then release_stmt
			when :ROLLBACK					then rollback_stmt
			when :SAVEPOINT					then savepoint_stmt
			when :SELECT						then select_stmt
			when :UPDATE						then update_stmt
			when :VACUUM						then vacuum_stmt
			when :WITH							then with_stmt
			else
				expected!(:ALTER, :ANALYZE, :ATTACH, :BEGIN, :COMMIT, :END, :CREATE, :DELETE, :DETACH, :DROP, :INSERT, :REPLACE, :PRAGMA, :REINDEX, :RELEASE, :ROLLBACK, :SAVEPOINT, :SELECT, :UPDATE, :VACUUM, :WITH)
			end
		end

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
						# elsif (s = optional { select_stmt })
						# 	require :RP

						# 	return expression_node.new(
						# 		member: left,
						# 		collection: s
						# 	)
						# 	# :nocov:
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
			elsif (id = optional { identifier(except: [:RAISE]) })
				case current_token
				in :IN
					ColumnReference.new(
						column_name: id,
					)
				in :LP
					function_name = id.to_sym.upcase
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
				in :DOT
					schema_or_table_name = id
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
						column_name: id,
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
				expressions = one_or_more { expression }
				order_by = maybe_all(:ORDER, :BY) ? one_or_more { ordering_term } : nil

				FunctionArguments.new(
					distinct:,
					expressions:,
					order_by:,
				)
			elsif maybe :STAR
				StarFunctionArgument.new
			elsif (e = optional { expression })
				expressions = one_or_more(given: e) { expression }
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
			condition = expression
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
				base_window_name = optional { identifier(except: [:PARTITION, :ORDER, :RANGE, :ROWS, :GROUPS]) }
				partition_by = maybe_all(:PARTITION, :BY) ? one_or_more { expression } : nil
				order_by = maybe_all(:ORDER, :BY) ? one_or_more { ordering_term } : nil
				frame = one_of?(:RANGE, :ROWS, :GROUPS) ? frame_spec : nil
				require :RP

				OverClause.new(
					base_window_name:,
					partition_by:,
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
					elsif (e = optional { expression })
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
				elsif (e = optional { expression })
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

		# TODO
		def alter_table_stmt
			#                           ┌────────────────────────┐
			# ◯─▶─{ ALTER }─▶{ TABLE }─▶┴▶{ schema-name }─▶{ . }─┴▶{ table-name }─┐
			# ┌───────────────────────────────────────────────────────────────────┘
			# ├─▶{ RENAME }─▶{ TO }─▶{ new-table-name }───────────────────────────────────┬─▶◯
			# ├─▶{ RENAME }─▶┬─▶{ COLUMN }─┬▶{ column-name }─▶{ TO }─▶{ new-column-name }─▶─┤
			# │            └──────▶──────┘                                                │
			# ├─▶{ ADD }─▶┬─▶{ COLUMN }─┬▶{ column-def }────────────────────────────────▶─┤
			# │           └──────▶──────┘                                                 │
			# └─▶{ DROP }─▶┬─▶{ COLUMN }─┬▶{ column-name }──────────────────────────────▶─┘
			#              └──────▶──────┘
			require current_token until current_token.nil?

			:alter_table_stmt
		end

		# TODO
		def analyze_stmt
			# ◯─▶{ ANALYZE }─▶┬────────────────────────▶───────────────────────────┬▶◯
			#                 ├▶{ schema-name }──────────────────────────────────▶─┤
			#                 ├▶{ index-or-table-name }──────────────────────────▶─┤
			#                 └▶{ schema-name }─▶{ . }─▶{ table-or-index-name }──▶─┘
			require current_token until current_token.nil?

			:analyze_stmt
		end

		# TODO
		def attach_stmt
			# ◯─▶{ ATTACH }─▶┬─▶{ DATABASE }┬▶[ expr ]─▶{ AS }─▶{ schema-name }─▶◯
			#                └───────▶──────┘
			require current_token until current_token.nil?

			:attach_stmt
		end

		# TODO
		def begin_stmt
			# ◯─▶{ BEGIN }─▶┬─────────────────┬▶┬▶{ TRANSACTION }┬┬▶{ name }┬─▶◯
			#               ├▶{ DEFERRED }──▶─┤ └────────▶───────┘└────▶────┘
			#               ├▶{ IMMEDIATE }─▶─┤
			#               └▶{ EXCLUSIVE }─▶─┘
			require :BEGIN
			either :DEFERRED, :IMMEDIATE, :EXCLUSIVE, nil
			maybe :TRANSACTION
			name = optional { identifier }

			:begin_stmt
		end

		# TODO
		def commit_stmt
			# ◯─▶┬▶{ COMMIT }┬▶┬─{ TRANSACTION }┬─▶◯
			#    └▶{ END }─▶─┘ └────────▶───────┘
			either :COMMIT, :END
			maybe :TRANSACTION

			:commit_stmt
		end

		# TODO
		def create_index_stmt
			# ◯─▶{ CREATE }┬─────▶─────┬▶{ INDEX }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
			#              └▶{ UNIQUE }┘          │                             │
			# ┌───────────────────────────────────┴─────────────────────────────┘
			# ├─▶{ schema-name }─▶{ . }─┬▶{ index-name }─▶{ ON }─▶{ table-name }─┐
			# └─────────────────────────┘                                        │
			# ┌──────────────────────────────────────────────────────────────────┘
			# └─▶{ ( }─┬▶[ indexed-column ]─┬▶{ ) }─┐
			#          └───────{ , }◀───────┘       │
			#               ┌─────◀─────────────────┤
			#               └─▶{ WHERE }─▶{ expression }──┴─▶─◯
			require :CREATE
			require current_token until current_token.nil?

			:create_index_stmt
		end

		def create_table_stmt
			# ◯─▶{ CREATE }┬───────▶──────┬▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
			#              ├▶{ TEMP }─────┤          │                             │
			#              └▶{ TEMPORARY }┘          │                             │
			# ┌─────────────────────◀────────────────┴──────────────────◀──────────┘
			# ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }┬───────▶{ AS }─▶[ select-stmt ]───▶─────┐
			# └────────▶────────────────┘               │                                        │
			# ┌────────────────────◀────────────────────┘                     ┌────────▶─────────┼─▶◯
			# └▶{ ( }─┬▶[ column-def ]─┬▶┬─────────────────────────────┬▶{ ) }┴▶[ table-options ]┘
			#         └─────{ , }◀─────┘ └[ table-constraint ]◀─{ ,|<nil> }◀─┘

			require :CREATE
			temporary = either(:TEMP, :TEMPORARY, nil)
			require :TABLE
			if_not_exists = maybe_all(:IF, :NOT, :EXISTS)
			schema_name, table_name = table_ref

			if maybe :AS
				as_select = select_stmt
				CreateTableStatement.new(
					schema_name:,
					table_name:,
					temporary: (true if temporary),
					if_not_exists: (true if if_not_exists),
					select_statement: as_select
				)
			elsif maybe :LP
				columns = one_or_more { column_def }
				constraints = zero_or_more(sep: :COMMA, optional: true) { table_constraint }
				require :RP
				options = optional { table_options } # nil || [:STRICT, true] || [true] || [:STRICT]

				CreateTableStatement.new(
					schema_name:,
					table_name:,
					temporary: (true if temporary),
					if_not_exists: (true if if_not_exists),
					strict: (true if options&.include?(:STRICT)),
					without_row_id: (true if options&.include?(true)),
					columns:,
					constraints: (constraints if constraints.any?),
				)
			else
				expected!(:AS, :LP)
			end
		end

		def column_def
			# ◯─▶{ column-name }─┬─▶[ type-name ]─┬▶┬─▶───────────────────▶──┬─▶◯
			#                    └────────▶───────┘ └─[ column-constraint ]◀─┘

			column_name = identifier
			type = optional { type_name }
			constraints = zero_or_more(sep: nil) { column_constraint }

			ColumnDefinition.new(
				name: column_name,
				type_name: type,
				constraints: (constraints if constraints.any?)
			)
		end

		def table_constraint
			# ◯─▶┬▶{ CONSTRAINT }─▶{ name }─┐
			#    ├─────────────◀────────────┘
			#    ├─▶{ PRIMARY }─▶{ KEY }───▶{ ( }┬▶[ indexed-column ]┬┬▶{ AUTOINCREMENT }┬▶{ ) }─▶[ conflict-clause ]───┬─▶◯
			#    │                               └───────{ , }◀──────┘└────────▶─────────┘                              │
			#    ├─▶{ UNIQUE }──▶{ ( }┬▶[ indexed-column ]┬▶{ ) }─▶[ conflict-clause ]────────────────────────────────▶─┤
			#    │                    └───────{ , }◀──────┘                                                             │
			#    ├─▶{ CHECK }─▶{ ( }─▶[ expr ]─▶{ ) }─────────────────────────────────────────────────────────────────▶─┤
			#    └─▶{ FOREIGN }─▶{ KEY }─▶{ ( }┬▶[ indexed-column ]┬▶{ ) }─▶[ foreign-key-clause ]────────────────────▶─┘
			#                                  └──────{ , }◀───────┘
			name = identifier if maybe :CONSTRAINT
			if maybe :UNIQUE
				require :LP
				columns = one_or_more { indexed_column }
				require :RP
				on_conflict = conflict_clause
				UniqueTableConstraint.new(
					name:,
					columns:,
					conflict_clause: on_conflict
				)
			elsif maybe :CHECK
				require :LP
				check = expression
				require :RP
				CheckTableConstraint.new(
					name:,
					expression: check,
				)
			elsif maybe_all :PRIMARY, :KEY
				require :LP
				columns = one_or_more { indexed_column }
				autoincrement = maybe :AUTOINCREMENT
				require :RP
				on_conflict = conflict_clause
				PrimaryKeyTableConstraint.new(
					name:,
					columns:,
					autoincrement: (true if autoincrement),
					conflict_clause: on_conflict
				)
			elsif maybe_all :FOREIGN, :KEY
				require :LP
				columns = one_or_more { indexed_column }
				require :RP
				clause = foreign_key_clause
				ForeignKeyTableConstraint.new(
					columns:,
					foreign_key_clause: clause,
				)
			else
				if name
					NoOpTableConstraint.new(name:)
				else
					expected!(:CONSTRAINT, :PRIMARY, :UNIQUE, :CHECK, :FOREIGN)
				end
			end
		end

		def table_options
			#     ┌─▶{ WITHOUT }─▶{ ROWID }─┐
			# ◯─┬─┤                         ├─┬─▶◯
			#   │ └─▶{ STRICT }─────────────┘ │
			#   └──────◀───────────────{ , }◀─┘
			one_or_more do
				maybe(:STRICT) || maybe_all(:WITHOUT, :ROWID) || expected!(:STRICT, :WITHOUT)
			end
		end

		# layer 2

		def type_name
			# ◯─┬▶{ name }─┬┬──────────────────────────────▶─────────────────────────────┬─▶◯
			#   └────◀─────┘├─▶{ ( }─▶[ signed-number ]─▶{ ) }─────────────────────────▶─┤
			#               └─▶{ ( }─▶[ signed-number ]─▶{ , }─▶[ signed-number ]─▶{ ) }─┘

			name = one_or_more(sep: nil) { identifier(except: [:PRIMARY, :NOT, :NULL, :UNIQUE, :CHECK, :DEFAULT, :COLLATE, :REFERENCES, :GENERATED, :AS]) }.join(" ")
			if maybe :LP
				constraints = one_or_more { signed_number }
				require :RP
			end

			case name
			when /INT/i							then	IntegerType.new(name:, constraints:)
			when /CHAR|CLOB|TEXT/i	then	TextType.new(name:, constraints:)
			when /BLOB/i						then	BlobType.new(name:, constraints:)
			when /REAL|FLOA|DOUB/i	then	RealType.new(name:, constraints:)
			else													AnyType.new(name:, constraints:)
			end
		end

		def column_constraint
			# ◯─▶┬▶{ CONSTRAINT }─▶{ name }─┬───────────────────────────────▶───────────────────────┐
			#    ├─────────────◀────────────┘                                                       │
			#    ├─▶{ PRIMARY }─▶{ KEY }──┬─────▶──────┬─▶[ conflict-clause ]┬──────────▶───────────┼─▶◯
			#    │                        ├─▶{ ASC }──▶┤                     └─▶{ AUTOINCREMENT }─▶─┤
			#    ├─────▶───┐              └─▶{ DESC }─▶┘                                            │
			#    ├─▶{ NOT }┴▶{ NULL }─▶[ conflict-clause ]────────────────────────────────────────▶─┤
			#    ├─▶{ UNIQUE }─▶[ conflict-clause ]───────────────────────────────────────────────▶─┤
			#    ├─▶{ CHECK }─▶{ ( }─▶[ expr ]─▶{ ) }─────────────────────────────────────────────▶─┤
			#    ├─▶{ DEFAULT }─▶┬▶{ ( }─▶[ expr ]─▶{ ) }──┬──────────────────────────────────────▶─┤
			#    │               ├─▶[ literal-value ]────▶─┤                                        │
			#    │               └─▶[ signed-number ]────▶─┘                                        │
			#    ├─▶{ COLLATE }─▶{ collation-name }───────────────────────────────────────────────▶─┤
			#    ├─▶[ foreign-key-clause ]────────────────────────────────────────────────────────▶─┤
			#    ├─▶{ GENERATED }─▶{ ALWAYS }┬▶{ AS }─▶{ ( }─▶[ expr ]─▶{ ) }┬────────────────────▶─┤
			#    └──────────────▶────────────┘                               ├─▶{ STORED }────────▶─┤
			#                                                                └─▶{ VIRTUAL }───────▶─┘

			name = identifier if maybe :CONSTRAINT

			if maybe_all :PRIMARY, :KEY
				direction = either(:ASC, :DESC, nil)
				on_conflict = conflict_clause
				autoincrement = maybe(:AUTOINCREMENT)

				PrimaryKeyColumnConstraint.new(
					name:,
					direction:,
					autoincrement: (true if autoincrement),
					conflict_clause: on_conflict
				)
			elsif maybe_all :NOT, :NULL
				on_conflict = conflict_clause

				NotNullColumnConstraint.new(
					name:,
					conflict_clause: on_conflict
				)
			elsif maybe :NULL
				on_conflict = conflict_clause

				NullColumnConstraint.new(
					name:,
					conflict_clause: on_conflict
				)
			elsif maybe :UNIQUE
				on_conflict = conflict_clause

				UniqueColumnConstraint.new(
					name:,
					conflict_clause: on_conflict
				)
			elsif maybe :CHECK
				require :LP
				check = expression
				require :RP

				CheckColumnConstraint.new(
					name:,
					expression: check
				)
			elsif maybe :DEFAULT
				if maybe :LP
					value = expression
					require :RP
					DefaultColumnConstraint.new(
						name:,
						value:
					)
				elsif (number = optional { signed_number })
					DefaultColumnConstraint.new(
						name:,
						value: number,
					)
				elsif (value = optional { literal_value })
					DefaultColumnConstraint.new(
						name:,
						value:
					)
				elsif one_of? :ID, :INDEXED
					DefaultColumnConstraint.new(
						name:,
						value: unwrap_id
					)
				else
					expected! :LP, "literal-value", "signed-number"
				end
			elsif maybe :COLLATE
				CollateColumnConstraint.new(
					name:,
					collation_name: identifier.to_sym.upcase
				)
			elsif :REFERENCES == current_token
				clause = foreign_key_clause

				ForeignKeyColumnConstraint.new(
					name:,
					foreign_key_clause: clause,
				)
			elsif maybe_all(:GENERATED, :ALWAYS, :AS) or maybe(:AS)
				require :LP
				default = expression
				require :RP
				type = either(:STORED, :VIRTUAL, nil)

				GeneratedAsColumnConstraint.new(
					name:,
					expression: default,
					type:,
				)
			else
				if name
					NoOpColumnConstraint.new(name:)
				else
					expected! :PRIMARY, :NOT, :NULL, :UNIQUE, :CHECK, :DEFAULT, :COLLATE, :REFERENCES, :GENERATED
				end
			end
		end

		def indexed_column
			# ◯─▶┬▶{ column-name }─┬┬─▶───────────────────────────────┬┬────────▶───┬────▶◯
			#    └▶[ expr ]─────▶──┘└─▶{ COLLATE }─▶{ collation-name }┘├─▶{ ASC }─▶─┤
			#                                                          └─▶{ DESC }──┘
			if :ID == current_token
				name = ColumnReference.new(column_name: identifier)
			elsif (e = optional { expression })
				name = (ColumnReference === e) ? e : ColumnReference.new(column_name: e)
			else
				expected! :ID, "expr"
			end
			collation = nil
			if maybe :COLLATE
				collation = identifier
			end
			direction = either :ASC, :DESC, nil

			IndexedColumn.new(
				column: name,
				expression: e,
				collation: collation,
				direction: direction
			)
		end

		def conflict_clause
			# ◯─▶┬────────────────────────────────────────┬─────▶◯
			#    └─▶{ ON }─▶{ CONFLICT }┬─▶{ ROLLBACK }─▶─┤
			#                           ├─▶{ ABORT }────▶─┤
			#                           ├─▶{ FAIL }─────▶─┤
			#                           ├─▶{ IGNORE }───▶─┤
			#                           └─▶{ REPLACE }──▶─┘
			if maybe_all :ON, :CONFLICT
				case current_token
				when :ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE
					require current_token
				else
					expected! :ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE
				end
			end
		end

		def ordering_term
			# ◯─▶[ expr ]┬───────────────▶────────────────┬▶┬──────▶─────┬▶┬──────────▶─────────────┬─▶◯
			#            └▶{ COLLATE }─▶{ collation-name }┘ ├▶{ ASC }──▶─┤ ├▶{ NULLS }─▶{ FIRST }─▶─┤
			#                                               └▶{ DESC }─▶─┘ └▶{ NULLS }─▶{ LAST }──▶─┘
			e = expression
			collation = maybe(:COLLATE) ? identifier : nil
			direction = one_of?(:ASC, :DESC) ? require(current_token) : nil
			nulls = maybe(:NULLS) ? require(current_token) : nil

			OrderingTerm.new(
				expression: e,
				collation: collation,
				direction: direction,
				nulls: nulls
			)
		end

		def signed_number
			# ◯─┬───▶────┬─▶{ numeric-literal }─▶◯
			#   ├─▶{ + }─┤
			#   └─▶{ - }─┘
			sign =
				if maybe :PLUS
					+1
				elsif maybe :MINUS
					-1
				else
					+1
				end

			numeric_literal * sign
		end

		def numeric_literal
			case current_token
			when :INTEGER
				value = current_value.to_i
				require :INTEGER
				value
			when :FLOAT
				value = current_value.to_f
				require :FLOAT
				value
			when :QNUMBER
				value = current_value.to_f
				value = value.to_i if value % 1 == 0
				require :QNUMBER
				value
			else
				expected!(:INTEGER, :FLOAT, :QNUMBER)
			end
		end

		def string_literal
			case current_token
			when :STRING
				value = current_value
				require :STRING
				bytesize = value.bytesize
				value.byteslice(1, bytesize - 2)
			else
				expected!(:STRING)
			end
		end

		def blob_literal
			if current_token == :BLOB
				value = current_value
				require current_token
				bytesize = value.bytesize
				# trim the leading /x'/i and trailing /'/ then decode the hexadecimal string
				[value.byteslice(2, bytesize - 3)].pack("H*")
			else
				expected!(:BLOB)
			end
		end

		def literal_value
			# ◯─┬─▶{ numeric-literal }────▶─┬─▶◯
			#   ├─▶{ string-literal }─────▶─┤
			#   ├─▶{ blob-literal }───────▶─┤
			#   ├─▶{ NULL }───────────────▶─┤
			#   ├─▶{ TRUE }───────────────▶─┤
			#   ├─▶{ FALSE }──────────────▶─┤
			#   ├─▶{ CURRENT_TIME }───────▶─┤
			#   ├─▶{ CURRENT_DATE }───────▶─┤
			#   └─▶{ CURRENT_TIMESTAMP }──▶─┘
			return LiteralNil if maybe :NULL
			return true if current_token == :ID && current_value.upcase == "TRUE" && require(:ID)
			return LiteralFalse if current_token == :ID && current_value.upcase == "FALSE" && require(:ID)
			return :CURRENT_TIME if maybe :CURRENT_TIME
			return :CURRENT_DATE if maybe :CURRENT_DATE
			return :CURRENT_TIMESTAMP if maybe :CURRENT_TIMESTAMP

			if (number = optional { numeric_literal })
				return number
			elsif (string = optional { string_literal })
				return string
			elsif (blob = optional { blob_literal })
				return blob
			end

			expected!(:INTEGER, :FLOAT, :QNUMBER, :STRING, :BLOB, :NULL, :TRUE, :FALSE, :CURRENT_TIME, :CURRENT_DATE, :CURRENT_TIMESTAMP)
		end

		def foreign_key_clause
			#                                              ┌─────{ , }◀─────┐
			# ◯─▶{ REFERENCES }─▶{ foreign-table }─┬─▶{ ( }┴▶{ column-name }┴▶{ ) }──┐
			#  ┌───────────────────────────────────┴──────────◀──┬───────────────────┘
			#  ├─▶{ ON }┬─▶{ DELETE }─┬┬─▶{ SET }─▶{ NULL }────▶─┤
			#  │        └─▶{ UPDATE }─┘├─▶{ SET }─▶{ DEFAULT }─▶─┤
			#  │                       ├─▶{ CASCADE }──────────▶─┤
			#  │                       ├─▶{ RESTRICT }─────────▶─┤
			#  │                       └─▶{ NO }─▶{ ACTION }───▶─┤
			#  ├─▶{ MATCH }─▶{ name }────────────────────────────┘
			#  ├────────────┬─▶{ DEFERRABLE }┬───────────────────────────────▶─┐
			#  ├─{ NOT }──▶─┘                ├─▶{ INITIALLY }─▶{ DEFERRED }──▶─┤
			#  │                             └─▶{ INITIALLY }─▶{ IMMEDIATE }─▶─┤
			#  └───────────────────────────────────────────────────────────────┴──────▶◯
			require :REFERENCES
			foreign_table = identifier(except: [:ON, :MATCH, :DEFERRABLE, :NOT])
			columns = nil
			if maybe :LP
				columns = one_or_more { identifier }
				require :RP
			end
			meta = {}
			while maybe :ON
				if maybe :DELETE
					key = :ON_DELETE
				elsif maybe :UPDATE
					key = :ON_UPDATE
				else
					expected!(:DELETE, :UPDATE)
				end

				meta[key] = nil
				if maybe :CASCADE
					meta[key] = :CASCADE
				elsif maybe :RESTRICT
					meta[key] = :RESTRICT
				elsif maybe_all :SET, :NULL
					meta[key] = :SET_NULL
				elsif maybe_all :SET, :DEFAULT
					meta[key] = :SET_DEFAULT
				elsif maybe_all :NO, :ACTION
					meta[key] = :NO_ACTION
				else
					expected!(:SET, :CASCADE, :RESTRICT, :NO)
				end
			end
			while maybe :MATCH
				meta[:MATCH] = identifier(except: [:ON, :MATCH, :DEFERRABLE, :NOT])
			end
			if maybe_all :DEFERRABLE, :INITIALLY, :DEFERRED
				meta[:DEFERRED] = true
			elsif maybe_all :DEFERRABLE, :INITIALLY, :IMMEDIATE
				meta[:DEFERRED] = false
			elsif maybe_all :NOT, :DEFERRABLE, :INITIALLY, :IMMEDIATE
				meta[:DEFERRED] = false
			elsif maybe_all :NOT, :DEFERRABLE, :INITIALLY, :DEFERRED
				meta[:DEFERRED] = false
			elsif maybe :DEFERRABLE
				meta[:DEFERRED] = false
			elsif maybe_all :NOT, :DEFERRABLE
				meta[:DEFERRED] = false
			end

			ForeignKeyClause.new(
				foreign_table:,
				columns: columns,
				on_delete: meta[:ON_DELETE],
				on_update: meta[:ON_UPDATE],
				match_name: meta[:MATCH],
				deferred: meta[:DEFERRED]
			)
		end

		# TODO
		def create_trigger_stmt
			# ◯─▶{ CREATE }┬───────▶──────┬▶{ TRIGGER }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
			#              ├▶{ TEMP }─────┤            │                             │
			#              └▶{ TEMPORARY }┘            │                             │
			# ┌─────────────────────◀──────────────────┴──────────────────◀──────────┘
			# ├─▶{ schema-name }─▶{ . }─┬▶{ trigger-name }┬▶{ BEFORE }──────────▶─┐
			# └────────▶────────────────┘                 ├▶{ AFTER }───────────▶─┤
			#                                             ├▶{ INSTEAD }─▶{ OF }─▶─┤
			# ┌────────────────◀──────────────────────────┴───────◀───────────────┘
			# ├▶{ DELETE }───────────────────────────────┬▶{ ON }▶{ table-name }─┐
			# ├▶{ INSERT }─────────────────────────────▶─┤                       │
			# └▶{ UPDATE }─┬───────────────────────────▶─┤                       │
			#              └▶{ OF }─┬▶{ column-name }─┬▶─┘                       │
			#                       └──────{ , }◀─────┘                          ▼
			# ┌────────────────────────◀──────┬──────────────────────────────────┘
			# └─▶{ FOR }─▶{ EACH }─▶{ ROW }─┬─┴▶{ WHEN }─▶[ expr ]─┐
			# ┌───────────────────────────◀─┴──────────────────────┘
			# │           ┌─────────────◀─────────────┐
			# └─▶{ BEGIN }┴▶┬▶[ update-stmt ]──┬▶{ ; }┴▶{ END }─────────────────────────▶◯
			#               ├▶[ insert-stmt ]─▶┤
			#               ├▶[ delete-stmt ]─▶┤
			#               └▶[ select-stmt ]─▶┘
			require current_token until current_token.nil?

			:create_trigger_stmt
		end

		# TODO
		def create_view_stmt
			# ◯─▶{ CREATE }┬───────▶──────┬▶{ VIEW }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
			#              ├▶{ TEMP }─────┤         │                             │
			#              └▶{ TEMPORARY }┘         │                             │
			# ┌─────────────────────◀───────────────┴──────────────────◀──────────┘
			# ├─▶{ schema-name }─▶{ . }─┬▶{ view-name }─┬──────────────────────────────────┬▶{ AS }─▶[ select-stmt ]─▶◯
			# └────────▶────────────────┘               └─▶{ ( }─┬▶{ column-name }─┬▶{ ) }─┘
			#                                                    └──────{ , }◀─────┘
			require current_token until current_token.nil?

			:create_view_stmt
		end

		# TODO
		def create_virtual_table_stmt
			# ◯─▶{ CREATE }─▶{ VIRTUAL }─▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
			# ┌────────────────────◀───────────────┴───────────◀─────────────────┘
			# ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }─┐
			# └────────▶────────────────┘                │
			# ┌────────────────────◀─────────────────────┘
			# │                            ┌─────────────────◀────────────────┐
			# └─▶{ USING }─▶{ module-name }┴▶{ ( }┬▶[ module-argument ]┬▶{ ) }┴────▶◯
			#                                     └────────{ , }◀──────┘
			require current_token until current_token.nil?

			:create_virtual_table_stmt
		end

		# TODO
		def delete_stmt
			# ◯─▶┬▶[ with-stmt ]─┐
			#    ├───────◀───────┘
			#    └─▶{ DELETE }─▶{ FROM }─▶[ qualified-table-name ]─┬──▶─┐
			#    ┌─────────────────────────◀───────────────────────┘    │
			#    ├─▶{ WHERE }─▶[ expr ]─┬─────────────────────────────▶─┤
			#    ├──────────◀───────────┘                               │
			#    ├─▶[ returning-clause ]─┬────────────────────────────▶─┤
			#    ├──────────◀────────────┘                              │
			#    ├─▶{ ORDER }─▶{ BY }┬▶[ ordering-term ]─┬────────────▶─┤
			#    │                   └───────{ , }◀──────┤              │
			#    ├────────────────◀──────────────────────┘              │
			#    └─▶{ LIMIT }─▶[ expr ]─┬────────────────────────┬▶─────┴─▶◯
			#                           ├─▶{ OFFSET }─▶[ expr ]─▶┤
			#                           └─▶{ , }─▶[ expr ]─▶─────┘
			require current_token until current_token.nil?

			:delete_stmt
		end

		# TODO
		def detach_stmt
			# ◯─▶{ DETACH }┬▶{ DATABASE }┬▶{ schema-name }─▶◯
			#              └──────▶──────┘
			require current_token until current_token.nil?

			:detach_stmt
		end

		# TODO
		def drop_index_stmt
			# ◯─▶{ DROP }─▶{ INDEX }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ index-name }─▶◯
			#                       └─────────▶─────────┘└───────────▶───────────┘
			require current_token until current_token.nil?

			:drop_index_stmt
		end

		# TODO
		def drop_table_stmt
			# ◯─▶{ DROP }─▶{ TABLE }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ table-name }─▶◯
			#                       └─────────▶─────────┘└───────────▶───────────┘
			require current_token until current_token.nil?

			:drop_table_stmt
		end

		# TODO
		def drop_trigger_stmt
			# ◯─▶{ DROP }─▶{ TRIGGER }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ trigger-name }─▶◯
			#                         └─────────▶─────────┘└───────────▶───────────┘
			require current_token until current_token.nil?

			:drop_trigger_stmt
		end

		# TODO
		def drop_view_stmt
			# ◯─▶{ DROP }─▶{ VIEW }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ view-name }─▶◯
			#                      └─────────▶─────────┘└───────────▶───────────┘
			require current_token until current_token.nil?

			:drop_view_stmt
		end

		# TODO
		def insert_stmt
			# ◯─▶┬▶[ with-stmt ]─┐
			#    ├───────◀───────┘
			#    ├─▶{ REPLACE }─────────────────────────┬─▶{ INTO }─┐
			#    └─▶{ INSERT }─┬───────────────────────▶┤           │
			#                  └▶{ OR }┬─▶{ ABORT }────▶┤           │
			#                          ├─▶{ FAIL }─────▶┤           │
			#                          ├─▶{ IGNORE }───▶┤           │
			#                          ├─▶{ REPLACE }──▶┤           │
			#                          └─▶{ ROLLBACK }─▶┘           │
			#    ┌───────────────────◀─────┬────────────────────────┘
			#    └─▶{ schema-name }─▶{ . }─┴▶{ table-name }─┬▶{ AS }─▶{ alias }─┐
			#    ┌──────────────────────────────────────────┴───────◀───────────┘
			#    ├─▶{ ( }─┬▶{ column-name }─┬─▶{ ) }─┐
			#    │        └─────{ , }◀──────┘        │
			#    ├──────────────────◀────────────────┘
			#    ├─▶{ VALUES }┬▶{ ( }─┬▶[ expr ]─┬─▶{ ) }┬───────────────────▶┐
			#    │            │       └──{ , }◀──┘       ├▶[ upsert-clause ]─▶┤
			#    │            └──────────{ , }◀──────────┘                    │
			#    ├─▶[ select-stmt ]──────────────────────┬───────────────────▶┤
			#    │                                       ├▶[ upsert-clause ]─▶┤
			#    └─▶{ DEFAULT }─▶{ VALUES }──────────────────────────────────▶┤
			#                                         ┌────────────◀──────────┤
			#                                         └─▶[ returning-clause ]─┴───▶◯
			require current_token until current_token.nil?

			:insert_stmt
		end

		# TODO
		def pragma_stmt
			# ◯─▶{ PRAGMA }┬▶{ schema-name }─▶{ . }┬▶{ pragma-name }┬─────────────────────────────────┬─▶◯
			#              └───────────▶───────────┘                ├─▶{ = }─▶[ pragma-value ]──────▶─┤
			#                                                       └─▶{ ( }─▶[ pragma-value ]─▶{ ) }─┘
			require current_token until current_token.nil?

			:pragma_stmt
		end

		# TODO
		def reindex_stmt
			# ◯─▶{ REINDEX }┬─────────────────────────▶────────────────────────┬─▶◯
			#               ├─▶{ collation-name }────────────────────────────▶─┤
			#               ├─▶{ schema-name }─▶{ . }┬▶┬▶{ table-name }──────▶─┤
			#               └────────▶───────────────┘ └▶{ index-name }──────▶─┘
			require current_token until current_token.nil?

			:reindex_stmt
		end

		# TODO
		def release_stmt
			# ◯─▶{ RELEASE }┬▶{ SAVEPOINT }┬▶{ savepoint-name }─▶◯
			#               └──────▶───────┘
			require current_token until current_token.nil?

			:release_stmt
		end

		# TODO
		def rollback_stmt
			#                                          ┌──────▶───────┐
			# ◯─▶{ ROLLBACK }┬▶{ TRANSACTION }┬┬▶{ TO }┴▶{ SAVEPOINT }┴▶{ savepoint-name }┬─▶◯
			#                └───────▶────────┘└─────────────────────▶────────────────────┘
			require current_token until current_token.nil?

			:rollback_stmt
		end

		# TODO
		def savepoint_stmt
			# ◯─▶{ SAVEPOINT }─▶{ savepoint-name }─▶◯
			require current_token until current_token.nil?

			:savepoint_stmt
		end

		# TODO
		def select_stmt
			# ◯─▶┬▶[ with-stmt ]─┐
			#    ├───────◀───────┘
			# ┌──┴▶┬─────▶{ SELECT }─┬───────▶──────┬─┬▶[ result-column ]─┐
			# │    │                 ├▶{ DISTINCT }┤  └─────{ , }◀────────┤
			# ▲    │                 └▶{ ALL }────▶┘                      │
			# │    │    ┌──────────────────────────◀──────────────────────┘
			# │    │    ├─▶{ FROM }┬─┬▶[ table-or-subquery ]─┬─┬─▶───┐
			# │    │    │          │ └────────{ , }◀─────────┘ ▲     ▼
			# │    │    │          └──▶[ join-clause ]─────────┘     │
			# │    │    ├──────────────────────◀─────────────────────┘
			# │    │    ├─▶{ WHERE }─▶[ expr ]─┐
			# │    │    ├──────────◀───────────┘
			# │    │    ├────────────▶─────────────────┐
			# │    │    ├─▶{ GROUP }─▶{ BY }┬▶[ expr ]┬┴▶┬─▶{ HAVING }─▶[ expr ]─┬─┐
			# │    │    ▼                   └──{ , }◀─┘  └────────▶──────────────┘ ▼
			# │    │    ├─────────────────────────────◀────────────────────────────┘
			# │    │    ├─▶{ WINDOW }┬▶{ window-name }─▶{ AS }─▶[ window-defn ]─┐
			# ▲    │    │            └───────────────────{ , }◀─────────────────┤
			# │    │    └──────────────────────▶─────────────────────────────▶──┤
			# │    │                    ┌──{ , }◀─┐                             ▼
			# │    └─▶{ VALUES }┬▶{ ( }─┴▶[ expr ]┴─▶{ ) }─┬─────────────────▶──┤
			# │                 └──────────{ , }◀──────────┘                    │
			# └────────────────────[ compound-operator ]◀───────────────────────┤
			#             ┌──────────────────◀──────────────────────────────────┘
			#             ├─▶{ ORDER }─▶{ BY }┬▶[ ordering-term ]─┬┐
			#             ▼                   └───────{ , }◀──────┘│
			#             ├────────────────◀───────────────────────┘
			#             ├─▶{ LIMIT }─▶[ expr ]─▶┬───────────────────────▶─┐
			#             │                       ├─▶{ OFFSET }─▶[ expr ]─▶─┤
			#             │                       └─▶{ , }─▶[ expr ]──────▶─┤
			#             └───────────────────────────────────────────────▶─┴───────▶◯
			require current_token until current_token.nil?

			:select_stmt
		end

		# TODO
		def update_stmt
			# ◯─▶┬▶[ with-stmt ]─┐
			#    ├───────◀───────┘
			#    └─▶{ UPDATE }─┬───────────────────────┬▶[ qualified-table-name ]─┐
			#                  ├▶{ OR }─▶{ ABORT }────▶┤                          │
			#                  ├▶{ OR }─▶{ FAIL }─────▶┤                          │
			#                  ├▶{ OR }─▶{ IGNORE }───▶┤                          │
			#                  ├▶{ OR }─▶{ REPLACE }──▶┤                          │
			#                  └▶{ OR }─▶{ ROLLBACK }─▶┘                          │
			#    ┌──────────────────────────◀─────────────────────────────────────┘
			#    └─▶{ SET }┬┬▶{ column-name }─────┬─▶{ = }─▶[ expr ]──┐
			#              │└▶[ column-name-list ]┘                   │
			#              └─────────────────{ , }◀───────────────────┤
			#    ┌──────────────────────────◀─────────────────────────┘
			#    ├─▶{ FROM }┬─┬▶[ table-or-subquery ]─┬─┬─▶───┐
			#    │          │ └────────{ , }◀─────────┘ │     │
			#    │          └──▶[ join-clause ]─────────┘     │
			#    ├──────────────────────◀─────────────────────┘
			#    ├─▶{ WHERE }─▶[ expr ]─┐
			#    ├──────────◀───────────┘
			#    ├─▶[ returning-clause ]─┐
			#    ├──────────◀────────────┘
			#    ├─▶{ ORDER }─▶{ BY }┬▶[ ordering-term ]─┐
			#    │                   └───────{ , }◀──────┤
			#    ├─────────────────◀─────────────────────┘
			#    ├─▶{ LIMIT }─▶[ expr ]─┬───────────────────────▶─┐
			#    │                      ├─▶{ OFFSET }─▶[ expr ]─▶─┤
			#    │                      └─▶{ , }─▶[ expr ]──────▶─┤
			#    └─────────────────────▶──────────────────────────┴─▶───────────────▶◯
			require current_token until current_token.nil?

			:update_stmt
		end

		# TODO
		def vacuum_stmt
			# ◯─▶{ VACUUUM }┬─────────────────┬▶┬────────────────────────┬─▶◯
			#               └▶{ schema-name }─┘ └▶{ INTO }─▶{ filename }─┘
			require current_token until current_token.nil?

			:vacuum_stmt
		end

		# TODO
		def with_stmt
			# ◯─▶{ WITH }┬───────▶──────┬─┬[ common-table-expression ]─┐
			#            └▶{ RECURSIVE }┘ └───────────{ , }◀───────────┤
			#  ┌───────────────────────────◀───────────────────────────┘
			#  ├─▶[ delete-stmt ]───────────────▶─┐
			#  ├─▶[ insert-stmt ]───────────────▶─┤
			#  ├─▶[ select-stmt ]───────────────▶─┤
			#  └─▶[ update-stmt ]───────────────▶─┴──────────────────────▶─◯
			require current_token until current_token.nil?

			:with_stmt
		end

		# nm ::= ID|INDEXED|JOIN_KW
		# nm ::= STRING
		def identifier(except: [])
			if :STRING == current_token
				string_literal
			elsif one_of? :ID
				unwrap_id
			elsif one_of? :INDEXED, :CROSS, :FULL, :INNER, :LEFT, :NATURAL, :OUTER, :RIGHT
				value = current_value
				require current_token
				value
			elsif !except.include?(current_token) && TOKEN_FALLBACKS[current_token]
				value = current_token.name
				require current_token
				value
			else
				expected!(:STRING, :ID, :INDEXED, :CROSS, :FULL, :INNER, :LEFT, :NATURAL, :OUTER, :RIGHT)
			end
		end

		def table_ref
			schema_or_table = identifier
			if maybe :DOT
				table = identifier
				[schema_or_table, table]
			else
				[nil, schema_or_table]
			end
		end

		def unwrap_id
			val = current_value
			require :ID
			case val.getbyte(0)
			when 96, 39, 34, 93 # "`", "'", '"', "]"
				bytesize = val.bytesize
				val.byteslice(1, bytesize - 2)
			else
				val
			end
		end

		private

		def require(token)
			if token == current_token
				advance
				token
			else
				expected!(token)
			end
		end

		def maybe(token)
			if token == current_token
				advance
				token
			end
		end

		def require_all(*tokens)
			# save one allocation as `Array#each` (at least up to Ruby 3.3) actually allocates one object
			i, len = 0, tokens.length
			while i < len
				if tokens[i] == current_token
					advance
					i += 1
				else
					expected!(tokens)
				end
			end

			true
		end

		def maybe_all(*tokens)
			advance = true
			i, len = 0, tokens.length
			buf = ensure_buffer(len)
			while i < len
				if tokens[i] != buf[i*3]
					advance = false
					break
				end
				i += 1
			end

			require_all(*tokens) if advance
		end

		def either(*options)
			i, len = 0, options.length
			while i < len
				option = options[i]
				if (result = maybe option)
					return result
				else
					i += 1
				end
			end

			option.nil? ? option : expected!(*options)
		end

		def one_of?(*tokens)
			tokens.any?(current_token)
		end

		def optional
			start_buffer = @peek_buffer.dup
			start_lexer_cursor = @lexer.cursor
			start_lexer_pos = @lexer.anchor

			result = catch(:ERROR) { yield }

			if ErrorMessage === result
				@peek_buffer = start_buffer
				@lexer.cursor = start_lexer_cursor
				@lexer.anchor = start_lexer_pos
				nil
			else
				result
			end
		end

		def one_or_more(sep: :COMMA, given: nil)
			[].tap do |a|
				a << (given || yield)

				if sep
					while maybe sep
						if (val = optional { yield })
							a << val
						else
							break
						end
					end
				else
					while (x = optional { yield })
						a << x
					end
				end
			end
		end

		def zero_or_more(sep: :COMMA, optional: false)
			[].tap do |a|
				first_val = optional { yield }

				if first_val
					a << first_val

					if sep && !optional
						while maybe(sep)
							a << yield
						end
					elsif sep && optional
						while (maybe(sep) && (x = yield)) || (x = optional { yield })
							a << x
						end
					else # sep == nil or false
						while (x = optional { yield })
							a << x
						end
					end
				end
			end
		end

		# Access the current token type in the lexer stream.
		# Reads but doesn't consume the token at the head of the buffer.
		def current_token
			buf = ensure_buffer
			buf[0]
		end

		# Access the string value for the current token.
		# Reads but doesn't consume the start_pos and end_pos values at the head of the buffer.
		def current_value
			buf = ensure_buffer
			beg = buf[1]
			fin = buf[2]

			@lexer.sql.byteslice(beg...fin)
		end

		# Peek at the next `n` tokens in the lexer stream.
		# Does not advance the lexer cursor and does not consider the current token.
		def peek(n = 1)
			buf = ensure_buffer(n + 1)
			return buf[3] if n == 1 # symbol element of the 2nd token

			[].tap do |a|
				i, len = 1, buf.length
				while i <= n
					a << buf[i*3]
					i += 1
				end
			end
		end

		# Advance the implicit cursor pointing to the first token in the buffer by `n` tokens.
		# Returns the new token at the head of the buffer.
		# Note: to shift a "token" from the buffer, we need to shift 3 elements (token, start_pos, end_pos).
		def advance(n = 1)
			ensure_buffer(n)
			(n*3).times { @peek_buffer.shift }
			current_token
		end

		# TODO: fix
		def values(n = 1)
			ensure_buffer(n)
			(0...n).map { |i| @lexer.value_at(@token_index + i) }
		end

		# Ensure that the `@peek_buffer` has at least `size` tokens.
		# Note: the buffer is a flat array of `[token, start_pos, end_pos]` triples,
		# so, a buffer of `size` 2 will have 6 elements (2 * 3).
		def ensure_buffer(size = 1)
			@peek_buffer.tap do |buf|
				while buf.size < (size * 3)
					buf << @lexer.next_token << @lexer.anchor << @lexer.cursor
				end
			end
		end

		def expected!(*expected)
			error!(current_token, current_value, expected)
		end

		def error!(token, value, expected)
			# TODO: we should handle multi-line sql highlighting
			highlight = (" " * @lexer.anchor) + ("^" * (@lexer.cursor - @lexer.anchor))
			msg = "Unexpected token #{token}[#{value.inspect}] at:\n  #{@lexer.sql.strip}\n  #{highlight}\n  Expected one of: #{expected.join(", ")}\n"

			throw :ERROR, ErrorMessage.new(msg)
		end
	end
end
