# frozen_string_literal: true

module Plume
	class Parser
		class ErrorMessage
			attr_reader :msg

			def initialize(msg)
				@msg = msg
			end
		end
		SyntaxError = Class.new(StandardError)
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

		def expr
			expression
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
			#               └─▶{ WHERE }─▶{ expr }──┴─▶─◯
			require :CREATE
			require current_token until current_token.nil?

			:create_index_stmt
		end

		def create_table_stmt
			CreateTableStatement()
		end

		def ordering_term
			# ◯─▶[ expr ]┬───────────────▶────────────────┬▶┬──────▶─────┬▶┬──────────▶─────────────┬─▶◯
			#            └▶{ COLLATE }─▶{ collation-name }┘ ├▶{ ASC }──▶─┤ ├▶{ NULLS }─▶{ FIRST }─▶─┤
			#                                               └▶{ DESC }─▶─┘ └▶{ NULLS }─▶{ LAST }──▶─┘
			e = expr
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
			elsif one_of? :ID, :INDEXED, :CROSS, :FULL, :INNER, :LEFT, :NATURAL, :OUTER, :RIGHT
				value = current_value
				require current_token
				value
			elsif !except.include?(current_token) && TOKEN_FALLBACKS[current_token]
				value = current_token
				require current_token
				value
			else
				expected!(:STRING, :ID, :INDEXED, :CROSS, :FULL, :INNER, :LEFT, :NATURAL, :OUTER, :RIGHT)
			end
		end

		# ---

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

		def zero_or_more(sep: :COMMA)
			[].tap do |a|
				first_val = optional { yield }

				if first_val
					a << first_val

					if sep
						while maybe sep
							a << yield
						end
					else
						while (x = optional { yield })
							a << x
						end
					end
				end
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
