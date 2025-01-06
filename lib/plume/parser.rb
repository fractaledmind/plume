# frozen_string_literal: true

module Plume
	class Parser
		Type = Class.new do
			attr_reader :name, :constraints
			def initialize(name, *constraints)
				@name = name
				@constraints = constraints
			end
			def inspect = "#{self.class.name.split("::").last}[#{name}]#{constraints.any? ? '(' + constraints.join(", ") + ')' : ''}"
			def to_s = inspect
		end
		Type::Integer = Class.new(Type)
		Type::Real = Class.new(Type)
		Type::Text = Class.new(Type)
		Type::Blob = Class.new(Type)
		Type::Any = Class.new(Type)

		SyntaxError = Class.new(StandardError)
		# see: https://github.com/sqlite/sqlite/blob/master/src/parse.y#L255-L283
		TOKEN_FALLBACKS = {
		  SEMI:					nil,
		  EXPLAIN:			:ID,
		  QUERY:				:ID,
		  PLAN:					:ID,
		  BEGIN:				:ID,
		  TRANSACTION:	nil,
		  DEFERRED:			:ID,
		  IMMEDIATE:		:ID,
		  EXCLUSIVE:		:ID,
		  COMMIT:				nil,
		  END:					:ID,
		  ROLLBACK:			:ID,
		  SAVEPOINT:		:ID,
		  RELEASE:			:ID,
		  TO:						nil,
		  TABLE:				nil,
		  CREATE:				nil,
		  IF:						:ID,
		  NOT:					nil,
		  EXISTS:				nil,
		  TEMP:					:ID,
		  LP:						nil,
		  RP:						nil,
		  AS:						nil,
		  COMMA:				nil,
		  WITHOUT:			:ID,
		  ABORT:				:ID,
		  ACTION:				:ID,
		  AFTER:				:ID,
		  ANALYZE:			:ID,
		  ASC:					:ID,
		  ATTACH:				:ID,
		  BEFORE:				:ID,
		  BY:						:ID,
		  CASCADE:			:ID,
		  CAST:					:ID,
		  CONFLICT:			:ID,
		  DATABASE:			:ID,
		  DESC:					:ID,
		  DETACH:				:ID,
		  EACH:					:ID,
		  FAIL:					:ID,
		  OR:						nil,
		  AND:					nil,
		  IS:						nil,
		  MATCH:				:ID,
		  LIKE_KW:			:ID,
		  BETWEEN:			nil,
		  IN:						nil,
		  ISNULL:				nil,
		  NOTNULL:			nil,
		  NE:						nil,
		  EQ:						nil,
		  GT:						nil,
		  LE:						nil,
		  LT:						nil,
		  GE:						nil,
		  ESCAPE:				nil,
		  ID:						nil,
		  COLUMNKW:			:ID,
		  DO:						:ID,
		  FOR:					:ID,
		  IGNORE:				:ID,
		  INITIALLY:		:ID,
		  INSTEAD:			:ID,
		  NO:						:ID,
		  KEY:					:ID,
		  OF:						:ID,
		  OFFSET:				:ID,
		  PRAGMA:				:ID,
		  RAISE:				:ID,
		  RECURSIVE:		:ID,
		  REPLACE:			:ID,
		  RESTRICT:			:ID,
		  ROW:					:ID,
		  ROWS:					:ID,
		  TRIGGER:			:ID,
		  VACUUM:				:ID,
		  VIEW:					:ID,
		  VIRTUAL:			:ID,
		  WITH:					:ID,
		  NULLS:				:ID,
		  FIRST:				:ID,
		  LAST:					:ID,
		  CURRENT:			:ID,
		  FOLLOWING:		:ID,
		  PARTITION:		:ID,
		  PRECEDING:		:ID,
		  RANGE:				:ID,
		  UNBOUNDED:		:ID,
		  EXCLUDE:			:ID,
		  GROUPS:				:ID,
		  OTHERS:				:ID,
		  TIES:					:ID,
		  GENERATED:		:ID,
		  ALWAYS:				:ID,
		  MATERIALIZED:	:ID,
		  REINDEX:			:ID,
		  RENAME:				:ID,
		  CTIME_KW:			:ID,
		  ANY:					nil,
		  BITAND:				nil,
		  BITOR:				nil,
		  LSHIFT:				nil,
		  RSHIFT:				nil,
		  PLUS:					nil,
		  MINUS:				nil,
		  STAR:					nil,
		  SLASH:				nil,
		  REM:					nil,
		  CONCAT:				nil,
		  PTR:					nil,
		  COLLATE:			nil,
		  BITNOT:				nil,
		  ON:						nil,
		  INDEXED:			nil,
		  STRING:				nil,
		  JOIN_KW:			nil,
		  CONSTRAINT:		nil,
		  DEFAULT:			nil,
		  NULL:					nil,
		  PRIMARY:			nil,
		  UNIQUE:				nil,
		  CHECK:				nil,
		  REFERENCES:		nil,
		  AUTOINCR:			nil,
		  INSERT:				nil,
		  DELETE:				nil,
		  UPDATE:				nil,
		  SET:					nil,
		  DEFERRABLE:		nil,
		  FOREIGN:			nil,
		  DROP:					nil,
		  UNION:				nil,
		  ALL:					nil,
		  EXCEPT:				nil,
		  INTERSECT:		nil,
		  SELECT:				nil,
		  VALUES:				nil,
		  DISTINCT:			nil,
		  DOT:					nil,
		  FROM:					nil,
		  JOIN:					nil,
		  USING:				nil,
		  ORDER:				nil,
		  GROUP:				nil,
		  HAVING:				nil,
		  LIMIT:				nil,
		  WHERE:				nil,
		  RETURNING:		nil,
		  INTO:					nil,
		  NOTHING:			nil,
		  FLOAT:				nil,
		  BLOB:					nil,
		  INTEGER:			nil,
		  VARIABLE:			nil,
		  CASE:					nil,
		  WHEN:					nil,
		  THEN:					nil,
		  ELSE:					nil,
		  INDEX:				nil,
		  ALTER:				nil,
		  ADD:					nil,
		  WINDOW:				nil,
		  OVER:					nil,
		  FILTER:				nil,
		  COLUMN:				nil,
		  AGG_FUNCTION:	nil,
		  AGG_COLUMN:		nil,
		  TRUEFALSE:		nil,
		  ISNOT:				nil,
		  FUNCTION:			nil,
		  UMINUS:				nil,
		  UPLUS:				nil,
		  TRUTH:				nil,
		  REGISTER:			nil,
		  VECTOR:				nil,
		  SELECT_COLUMN:nil,
		  IF_NULL_ROW:	nil,
		  ASTERISK:			nil,
		  SPAN:					nil,
		  ERROR:				nil,
		  SPACE:				nil,
		  ILLEGAL:			nil
		}

		def initialize(sql)
			@sql = sql
			@lexer = Lexer.new(sql, skip_spaces: true)
			@token_index = 0
			@peek_buffer = []
		end

		def parse
			sql_stmt_list
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

		{
			node1: [:node2, :node3],
			node2: [:PLAN]
		}

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

			accept :PLAN if (explain = maybe :EXPLAIN) && (query_plan = maybe :QUERY)

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
				when :TEMP
					case peek(2)
					when [:TEMP, :TABLE]		then create_table_stmt
					when [:TEMP, :TRIGGER]	then create_trigger_stmt
					when [:TEMP, :VIEW]			then create_view_stmt
					else
						error!(peek(2).last, values(3).last, [:TABLE, :TRIGGER, :VIEW])
					end
				else
					error!(peek, values(2).last, [:INDEX, :TABLE, :TRIGGER, :VIEW, :VIRTUAL, :UNIQUE, :TEMP])
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
					unexpected_token = peek
					*context, unexpected = values(2)
					raise SyntaxError, <<~TXT
						Unexpected token after '#{context.join(" ")}': #{unexpected_token}[#{unexpected.inspect}]
						Expected one of: INDEX, TABLE, TRIGGER, VIEW
					TXT
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
				error!(current_token, current_value, [:ALTER, :ANALYZE, :ATTACH, :BEGIN, :COMMIT, :END, :CREATE, :DELETE, :DETACH, :DROP, :INSERT, :REPLACE, :PRAGMA, :REINDEX, :RELEASE, :ROLLBACK, :SAVEPOINT, :SELECT, :UPDATE, :VACUUM, :WITH])
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
			accept :ALTER, :TABLE

			:alter_table_stmt
		end

		# TODO
		def analyze_stmt
			# ◯─▶{ ANALYZE }─▶┬────────────────────────▶───────────────────────────┬▶◯
			#                 ├▶{ schema-name }──────────────────────────────────▶─┤
			#                 ├▶{ index-or-table-name }──────────────────────────▶─┤
			#                 └▶{ schema-name }─▶{ . }─▶{ table-or-index-name }──▶─┘
			accept :ANALYZE

			:analyze_stmt
		end

		# TODO
		def attach_stmt
			# ◯─▶{ ATTACH }─▶┬─▶{ DATABASE }┬▶[ expr ]─▶{ AS }─▶{ schema-name }─▶◯
			#                └───────▶──────┘
			accept :ATTACH

			:attach_stmt
		end

		# TODO
		def begin_stmt
			# ◯─▶{ BEGIN }─▶┬─────────────────┬▶┬▶{ TRANSACTION }┬─▶◯
			#               ├▶{ DEFERRED }──▶─┤ └────────▶───────┘
			#               ├▶{ IMMEDIATE }─▶─┤
			#               └▶{ EXCLUSIVE }─▶─┘
			accept :BEGIN

			:begin_stmt
		end

		# TODO
		def commit_stmt
			# ◯─▶┬▶{ COMMIT }┬▶┬─{ TRANSACTION }┬─▶◯
			#    └▶{ END }─▶─┘ └────────▶───────┘
			maybe :COMMIT or maybe :END
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
			accept :CREATE

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
			#         └─────{ , }◀─────┘ └[ table-constraint ]◀─{ , }◀─┘
			accept :CREATE
			temporary = maybe(:TEMP) or maybe(:TEMPORARY)
			accept :TABLE
			if_not_exists = maybe(:IF, :NOT, :EXISTS)
			schema_or_table_name = identifier
			ref = if maybe :DOT
							TableRef[schema_or_table_name, identifier]
						else
							TableRef[schema_or_table_name]
						end
			if maybe :AS
				accept :AS
			elsif maybe :LP
				accept :LP
				columns = [].tap do |a|
					a << column_def
					a << column_def while maybe :COMMA
				end
				constraints = [].tap do |a|
					a << table_constraint while maybe :COMMA
				end
				accept :RP
			else
				error!(current_token, current_value, [:AS, :LP])
			end


			{
				CREATE_TABLE: {
					ref => columns,
					TEMPORARY: temporary,
					IF_NOT_EXISTS: if_not_exists,
					WITHOUT_ROWID: false,
					STRICT: false,
				}
			}
		end

		def column_def
			# ◯─▶{ column-name }─┬─▶[ type-name ]─┬▶┬─▶───────────────────▶──┬─▶◯
			#                    └────────▶───────┘ └─[ column-constraint ]◀─┘

			column_name = identifier
			type = optional { type_name }

			# constraints = [] << x while (x = optional { column_constraint })

			constraints = [].tap do |a|
				while (x = optional { column_constraint })
					a << x
				end
			end

			{ ColumnRef[column_name] => [type, constraints] }
		end

		def type_name
			# ◯─┬▶{ name }─┬┬──────────────────────────────▶─────────────────────────────┬─▶◯
			#   └────◀─────┘├─▶{ ( }─▶[ signed-number ]─▶{ ) }─────────────────────────▶─┤
			#               └─▶{ ( }─▶[ signed-number ]─▶{ , }─▶[ signed-number ]─▶{ ) }─┘

			name = String.new.tap do |a|
				a << identifier
				while (x = optional { identifier })
					a << " " << x
				end
			end

			a, b = nil, nil
			case current_token
			when :LP
				accept :LP
				a = signed_number
				case current_token
				when :COMMA
					accept :COMMA
					b = signed_number
					accept :RP
				when :RP
					accept :RP
				end
			end

			case name
			when /INT/i							then	Type::Integer.new(name, a, b)
			when /CHAR|CLOB|TEXT/i	then	Type::Text.new(name, a, b)
			when /BLOB/i						then	Type::Blob.new(name, a, b)
			when /REAL|FLOA|DOUB/i	then	Type::Real.new(name, a, b)
			else													Type::Any.new(name, a, b)
			end
		end

		# TODO
		def column_constraint
			# ◯─▶┬▶{ CONSTRAINT }─▶{ name }─┐
			#    ├─────────────◀────────────┘
			#    ├─▶{ PRIMARY }─▶{ KEY }──┬─────▶──────┬─▶[ conflict-clause ]┬──────────▶───────────┬─▶◯
			#    │                        ├─▶{ ASC }──▶┤                     └─▶{ AUTOINCREMENT }─▶─┤
			#    │                        └─▶{ DESC }─▶┘                                            │
			#    ├─▶{ NOT }─▶{ NULL }─▶[ conflict-clause ]────────────────────────────────────────▶─┤
			#    ├─▶{ UNIQUE }─▶[ conflict-clause ]───────────────────────────────────────────────▶─┤
			#    ├─▶{ CHECK }─▶{ ( }─▶[ expr ]─▶{ ) }─────────────────────────────────────────────▶─┤
			#    ├─▶{ DEFAULT }─▶┬▶{ ( }─▶[ expr ]─▶{ ) }──┬──────────────────────────────────────▶─┤
			#    │               ├─▶[ literal-value ]────▶─┤                                        │
			#    │               └─▶[ signed-number ]────▶─┘                                        │
			#    ├─▶{ COLLATE }─▶{ collation-name }───────────────────────────────────────────────▶─┤
			#    ├─▶[ foreign-key-clause ]────────────────────────────────────────────────────────▶─┤
			#    ├─▶{ GENERATED }─▶{ ALWAYS }┬▶{ AS }─▶{ ( }─▶[ expr ]─▶{ ) }┬────────────────────▶─┤
			#    └──────────────▶────────────┘                               ├─▶{ STORED }────────▶─┤
			#                                                                └─▶{ VIRUAL }────────▶─┘
			name = identifier if maybe :CONSTRAINT
			if maybe :PRIMARY, :KEY
				direction = maybe(:ASC) || maybe(:DESC) || true
				on_conflict = conflict_clause
				autoincrement = { AUTOINCREMENT: true } if maybe(:AUTOINCR)

				if on_conflict or autoincrement or name
					{ PRIMARY_KEY: [direction, on_conflict, autoincrement, ({NAME: name} if name)].compact! }
				else
					{ PRIMARY_KEY: direction }
				end
			elsif maybe :NOT, :NULL
				on_conflict = conflict_clause

				if on_conflict or name
					{ NOT_NULL: [true, on_conflict, ({NAME: name} if name)].compact! }
				else
					{ NOT_NULL: true }
				end
			elsif maybe :UNIQUE
				on_conflict = conflict_clause

				if on_conflict or name
					{ UNIQUE: [true, on_conflict, ({NAME: name} if name)].compact! }
				else
					{ UNIQUE: true }
				end
			elsif maybe :CHECK
				accept :LP
				check = expr
				accept :RP
				if name
					{ CHECK: [check, {NAME: name}] }
				else
					{ CHECK: check }
				end
			elsif maybe :DEFAULT

			elsif maybe :COLLATE
				{ COLLATE: identifier }
			elsif :REFERENCES == current_token
				foreign_key_clause
			elsif maybe(:GENERATED, :ALWAYS, :AS) or maybe(:AS)
				accept :LP
				expr = expr
				accept :RP
				{ GENERATED_AS: expr }
			end
		end

		# TODO
		def expr
			# ◯┬─▶[ literal-value ]───────────────────────────────────────────────────────────────────────────────────┬─▶◯
			#  ├─▶{ bind-parameter }────────────────────────────────────────────────────────────────────────────────▶─┤
			#  ├────────────────────────┬──────────────────────┐                                                      │
			#  ├─▶{ schema-name }─▶{ . }┴▶{ table-name }─▶{ . }┴▶{ column-name }────────────────────────────────────▶─┤
			#  ├─▶{ unary-operator }─▶[ expr ]──────────────────────────────────────────────────────────────────────▶─┤
			#  ├─▶[ expr ] { binary-operator }─▶[ expr ]────────────────────────────────────────────────────────────▶─┤
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
			#  ├─▶[ expr ]─▶{ IS }┬▶{ NOT }┬┬▶{ DISTINCT }─▶{ FROM }┬▶{ expr }──────────────────────────────────────▶─┤
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

			if maybe :CAST
				accept :LP
				e = expr
				accept :AS
				t = type_name
				accept :RP

				return { e => { CAST: t } }
			elsif maybe :NOT
				if maybe :EXISTS
					accept :LP
					s = select_stmt
					accept :RP

					return { NOT_EXISTS: s }
				else
					e = expr

					return { NOT: e }
				end
			elsif if maybe :EXISTS
				accept :LP
				s = select_stmt
				accept :RP

				{ EXISTS: s }
			elsif maybe :CASE
				if :WHEN == current_token
					branches = {}.tap do |h|
						while maybe :WHEN
							condition = expr
							accept :THEN
							result = expr

							h[condition] = result
						end
					end
					if maybe :ELSE
						branches[:ELSE] = expr
					end
					accept :END

					{ CASE: branches }
				else
					base = expr
					branches = {}.tap do |h|
						while maybe :WHEN
							condition = expr
							accept :THEN
							result = expr

							h[condition] = result
						end
					end
					if maybe :ELSE
						branches[:ELSE] = expr
					end
					accept :END

					{ CASE: [base, branches] }
				end
			elsif maybe :RAISE
				raise_function
			elsif maybe :LP
				exprs = [].tap do |a|
					a << expr
					a << expr while maybe :COMMA
				end
				accept :RP

				return exprs
			elsif (v = optional { literal_value })
				v
			elsif :VARIABLE == current_token
			elsif :ID == current_token
				schema_or_table_or_column_or_function_name = identifier
				if maybe :LP
					args = function_arguments
					accept :RP
				elsif maybe :DOT
					table_or_column_name = identifier
					if maybe :DOT
						column_name = identifier
					 	ref = ColumnRef[schema_or_table_or_column_name, table_or_column_name, column_name]
					else
						ref = ColumnRef[schema_or_table_or_column_name, table_or_column_name]
					end
				else
					ref = ColumnRef[schema_or_table_or_column_name]
				end
			elsif maybe :PLUS
				return expr
			elsif maybe :MINUS
				return { NEGATE: expr }
			elsif maybe :BITNOT
				return { INVERT: expr }
			elsif (lexpr = optional { expr })
				if maybe :COLLATE
					{ lexpr => { COLLATE: identifier } }
				elsif maybe :NOT, :LIKE
					rexpr = expr
					if maybe :ESCAPE
						escape = expr
						{ lexpr => { NOT_LIKE: [rexpr, { ESCAPE: escape }] } }
					else
						{ lexpr => { NOT_LIKE: rexpr } }
					end
				elsif maybe :LIKE
					rexpr = expr
					if maybe :ESCAPE
						escape = expr
						{ lexpr => { LIKE: [rexpr, { ESCAPE: escape }] } }
					else
						{ lexpr => { LIKE: rexpr } }
					end
				elsif maybe :NOT, :GLOB
					{ lexpr => { NOT_GLOB: expr } }
				elsif maybe :GLOB
					{ lexpr => { GLOB: expr } }
				elsif maybe :NOT, :REGEXP
					{ lexpr => { NOT_REGEXP: expr } }
				elsif maybe :REGEXP
					{ lexpr => { REGEXP: expr } }
				elsif maybe :NOT, :MATCH
					{ lexpr => { NOT_MATCH: expr } }
				elsif maybe :MATCH
					{ lexpr => { MATCH: expr } }
				elsif maybe :ISNULL
					{ lexpr => { IS: nil } }
				elsif maybe :NOTNULL
					{ lexpr => { IS_NOT: nil } }
				elsif maybe :NOT, :NULL
					{ lexpr => { IS_NOT: nil } }
				elsif maybe :IS, :NOT
					if maybe :DISTINCT, :FROM
						{ lexpr => { IS: expr } }
					else
						{ lexpr => { IS_NOT: expr } }
					end
				elsif maybe :IS
					if maybe :DISTINCT, :FROM
						{ lexpr => { IS_NOT: expr } }
					else
						{ lexpr => { IS: expr } }
					end
				elsif maybe :NOT, :BETWEEN
					rexpr1 = expr
					accept :AND
					rexpr2 = expr
					{ lexpr => { NOT_BETWEEN: [rexpr1, rexpr2] } }
				elsif maybe :BETWEEN
					rexpr1 = expr
					accept :AND
					rexpr2 = expr
					{ lexpr => { BETWEEN: [rexpr1, rexpr2] } }
				elsif maybe :NOT, :IN
					if maybe :LP
						if maybe :RP
							{ lexpr => { NOT_IN: [] } }
						elsif (s = optional { select_stmt })
							accept :RP

							{ lexpr => { NOT_IN: s } }
						elsif (e = optional { expr })
							exprs = [].tap do |a|
								a << e
								a << expr while maybe :COMMA
							end
							accept :RP

							{ lexpr => { NOT_IN: exprs } }
						else
							error!(current_token, current_value, [:RP, "select-stmt", "expr"])
						end
					elsif :ID == current_token
						schema_or_table = identifier
						if maybe :DOT
							table = identifier
							ref = TableRef[schema_or_table, table]
						else
							ref = TableRef[schema_or_table]
						end

						if maybe :LP
							if maybe :RP
								{ lexpr => { NOT_IN: { FN: { ref => [] } } } }
							elsif (e = optional { expr })
								exprs = [].tap do |a|
									a << e
									a << expr while maybe :COMMA
								end
								accept :RP

								{ lexpr => { NOT_IN: { FN: { ref => exprs } } } }
							else
								error!(current_token, current_value, [:RP, "expr"])
							end
						else
							{ lexpr => { NOT_IN: ref } }
						end
					else
						error!(current_token, current_value, [:LP, :ID])
					end
				elsif maybe :IN
					if maybe :LP
						if maybe :RP
							{ lexpr => { IN: [] } }
						elsif (s = optional { select_stmt })
							accept :RP

							{ lexpr => { IN: s } }
						elsif (e = optional { expr })
							exprs = [].tap do |a|
								a << e
								a << expr while maybe :COMMA
							end
							accept :RP

							{ lexpr => { IN: exprs } }
						else
							error!(current_token, current_value, [:RP, "select-stmt", "expr"])
						end
					elsif :ID == current_token
						schema_or_table = identifier
						if maybe :DOT
							table = identifier
							ref = TableRef[schema_or_table, table]
						else
							ref = TableRef[schema_or_table]
						end

						if maybe :LP
							if maybe :RP
								{ lexpr => { IN: { FN: { ref => [] } } } }
							elsif (e = optional { expr })
								exprs = [].tap do |a|
									a << e
									a << expr while maybe :COMMA
								end
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
				elsif maybe :CONCAT
					{ lexpr => { CONCAT: expr } }
				elsif :PTR == current_token
					if current_value == "->"
						{ lexpr => { EXTRACT: expr } }
					elsif current_value == "->>"
						{ lexpr => { RETRIEVE: expr } }
					else
						error!(current_token, current_value, ["->", "->>"])
					end
				elsif maybe :STAR
					{ lexpr => { MULTIPLY: expr } }
				elsif maybe :SLASH
					{ lexpr => { DIVIDE: expr } }
				elsif maybe :REM
					{ lexpr => { MODULO: expr } }
				elsif maybe :PLUS
					{ lexpr => { ADD: expr } }
				elsif maybe :MINUS
					{ lexpr => { SUB: expr } }
				elsif maybe :BITAND
					{ lexpr => { BIT_AND: expr } }
				elsif maybe :BITOR
					{ lexpr => { BIT_OR: expr } }
				elsif maybe :LSHIFT
					{ lexpr => { BIT_LSHIFT: expr } }
				elsif maybe :RSHIFT
					{ lexpr => { BIT_RSHIFT: expr } }
				elsif maybe :GT
					{ lexpr => { ABOVE: expr } }
				elsif maybe :LT
					{ lexpr => { BELOW: expr } }
				elsif maybe :GE
					{ lexpr => { ATLEAST: expr } }
				elsif maybe :LE
					{ lexpr => { ATMOST: expr } }
				elsif maybe :EQ
					{ lexpr => { EQUALS: expr } }
				elsif maybe :NE
					{ lexpr => { NOT_EQUALS: expr } }
				elsif maybe :AND
					{ ALL: [lexpr, expr] }
				elsif maybe :OR
					{ ANY: [lexpr, expr] }
				else
				end
			else
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
				exprs = [].tap do |a|
					a << expr
					a << expr while maybe :COMMA
				end
				if maybe :ORDER, :BY
					terms = [].tap do |a|
						a << ordering_term
						a << ordering_term while maybe :COMMA
					end
				else
				end
			elsif maybe :STAR
			elsif (e = optional { expr })
			end
		end

		def ordering_term
			# ◯─▶[ expr ]┬───────────────▶────────────────┬▶┬──────▶─────┬▶┬──────────▶─────────────┬─▶◯
			#            └▶{ COLLATE }─▶{ collation-name }┘ ├▶{ ASC }──▶─┤ ├▶{ NULLS }─▶{ FIRST }─▶─┤
			#                                               └▶{ DESC }─▶─┘ └▶{ NULLS }─▶{ LAST }──▶─┘
			e = expr
			if maybe :COLLATE
				collation = identifier
			end
			direction = :ASC
			if one_of? :ASC, :DESC
				direction = accept current_token
			end
			if maybe :NULLS
				nulls = maybe(:FIRST) || maybe(:LAST)
			end

			key = collation ? [e, collation] : e
			return { key => direction } unless nulls

			value = nulls == :FIRST ? [nil, direction] : [direction, nil]
			{ key => value }
		end

		def raise_function
			# ◯─▶{ RAISE }─▶{ ( }┬─▶{ IGNORE }────────────────────▶─────────┬▶{ ) }──▶◯
			#                    ├─▶{ ROLLBACK }─┬▶{ , }─▶{ error-message }─┘
			#                    ├─▶{ ABORT }──▶─┤
			#                    └─▶{ FAIL }───▶─┘
			accept :RAISE, :LP
			if maybe :IGNORE
				accept :RP

				{ RAISE: :IGNORE }
			elsif maybe :ROLLBACK
				accept :COMMA
				error_message = identifier
				accept :RF

				{ RAISE: { ROLLBACK: error_message } }
			elsif maybe :ABORT
				accept :COMMA
				error_message = identifier
				accept :RF

				{ RAISE: { ABORT: error_message } }
			elsif maybe :FAIL
				accept :COMMA
				error_message = identifier
				accept :RF

				{ RAISE: { FAIL: error_message } }
			end
		end

		def conflict_clause
			# ◯─▶┬────────────────────────────────────────┬─────▶◯
			#    └─▶{ ON }─▶{ CONFLICT }┬─▶{ ROLLBACK }─▶─┤
			#                           ├─▶{ ABORT }────▶─┤
			#                           ├─▶{ FAIL }─────▶─┤
			#                           ├─▶{ IGNORE }───▶─┤
			#                           └─▶{ REPLACE }──▶─┘
			if maybe :ON, :CONFLICT
				case current_token
				when :ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE
					{ ON_CONFLICT: accept(current_token) }
				else
					error!(current_token, current_value, [:ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE])
				end
			end
		end

		def signed_number
			# ◯─┬───▶────┬─▶{ numeric-literal }─▶◯
			#   ├─▶{ + }─┤
			#   └─▶{ - }─┘
			sign =	case current_token
							when :PLUS
								accept :PLUS
								+1
							when :MINUS
								accept :MINUS
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
				accept :INTEGER
				return value
			when :FLOAT
				value = current_value.to_f
				accept :FLOAT
				return value
			when :QNUMBER
				value = current_value.to_f
				value = (value % 1 == 0) ? value.to_i : value
				accept :QNUMBER
				return value
			else
				error!(current_token, current_value, [:INTEGER, :FLOAT, :QNUMBER])
			end
		end

		def string_literal
			if one_of? :STRING, :ID
				value = current_value
				accept current_token
				return value
			elsif TOKEN_FALLBACKS[current_token]
				value = @lexer.value
				accept current_token
				value
			else
				error!(current_token, current_value, [:STRING, :ID, *TOKEN_FALLBACKS.reject { |_, v| v.nil? }.keys])
			end
		end

		def blob_literal
			if current_token == :BLOB
				value = current_value
				accept current_token
				return value
			else
				error!(current_token, current_value, [:BLOB])
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
			return nil if maybe :NULL
			return true if current_token == :ID && current_value.upcase == "TRUE" && accept(:ID)
			return false if current_token == :ID && current_value.upcase == "FALSE" && accept(:ID)
			return :CURRENT_TIME if maybe :CURRENT_TIME
			return :CURRENT_DATE if maybe :CURRENT_DATE
			return :CURRENT_TIMESTAMP if maybe :CURRENT_TIMESTAMP
			return number if (number = optional { numeric_literal })
			return string if (string = optional { string_literal })
			return blob if (blob = optional { blob_literal })

			error!(current_token, current_value, [:INTEGER, :FLOAT, :QNUMBER, :STRING, :BLOB, :NULL, :TRUE, :FALSE, :CURRENT_TIME, :CURRENT_DATE, :CURRENT_TIMESTAMP])
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
			accept :REFERENCES
			foreign_table = identifier
			columns = nil
			if maybe :LP
				columns = [].tap do |a|
					a << identifier
					a << identifier while maybe :COMMA
				end
				accept :RP
			end
			meta = {}
			while maybe :ON
				if maybe :DELETE
					key = :ON_DELETE
				elsif maybe :UPDATE
					key = :ON_UPDATE
				else
					error!(current_token, current_value, [:DELETE, :UPDATE])
				end

				meta[key] = nil
				if maybe :SET, :NULL
					meta[key] = :SET_NULL
				elsif maybe :SET, :DEFAULT
					meta[key] = :SET_DEFAULT
				elsif maybe :CASCADE
					meta[key] = :CASCADE
				elsif maybe :RESTRICT
					meta[key] = :RESTRICT
				elsif maybe :NO, :ACTION
					meta[key] = :NO_ACTION
				else
					error!(current_token, current_value, [:SET, :CASCADE, :RESTRICT, :NO])
				end
			end
			while maybe :MATCH
				meta[:MATCH] = identifier
			end
			if maybe :DEFERRABLE, :INITIALLY, :DEFERRED
				meta[:DEFERRED] = true
			elsif maybe :DEFERRABLE
				meta[:DEFERRED] = false
			elsif maybe :NOT, :DEFERRABLE
				meta[:DEFERRED] = false
			elsif maybe :DEFERRABLE, :INITIALLY, :IMMEDIATE
				meta[:DEFERRED] = false
			elsif maybe :NOT, :DEFERRABLE, :INITIALLY, :IMMEDIATE
				meta[:DEFERRED] = false
			elsif maybe :NOT, :DEFERRABLE, :INITIALLY, :IMMEDIATE
				meta[:DEFERRED] = false
			end

			if meta.any?
				{ REFERENCES: [ColumnRef[foreign_table, columns], meta] }
			else
				{ REFERENCES: ColumnRef[foreign_table, columns] }
			end
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
			# ├─▶{ FOR }─▶{ EACH }─▶{ ROW }─┬─┴▶{ WHEN }─▶[ expr ]─┐
			# ┌───────────────────────────◀─┴──────────────────────┘
			# │           ┌─────────────◀─────────────┐
			# └─▶{ BEGIN }┴▶┬▶[ update-stmt ]──┬▶{ ; }┴▶{ END }─────────────────────────▶◯
			#               ├▶[ insert-stmt ]─▶┤
			#               ├▶[ delete-stmt ]─▶┤
			#               └▶[ select-stmt ]─▶┘
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
		end

		# TODO
		def detach_stmt
			# ◯─▶{ DETACH }┬▶{ DATABASE }┬▶{ schema-name }─▶◯
			#              └──────▶──────┘
		end

		# TODO
		def drop_index_stmt
			# ◯─▶{ DROP }─▶{ INDEX }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ index-name }─▶◯
			#                       └─────────▶─────────┘└───────────▶───────────┘
		end

		# TODO
		def drop_table_stmt
			# ◯─▶{ DROP }─▶{ TABLE }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ table-name }─▶◯
			#                       └─────────▶─────────┘└───────────▶───────────┘
		end

		# TODO
		def drop_trigger_stmt
			# ◯─▶{ DROP }─▶{ TRIGGER }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ trigger-name }─▶◯
			#                         └─────────▶─────────┘└───────────▶───────────┘
		end

		# TODO
		def drop_view_stmt
			# ◯─▶{ DROP }─▶{ VIEW }┬▶{ IF }─▶{ EXISTS }┬┬▶{ schema-name }─▶{ . }┬▶{ view-name }─▶◯
			#                      └─────────▶─────────┘└───────────▶───────────┘
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
		end

		# TODO
		def pragma_stmt
			# ◯─▶{ PRAGMA }┬▶{ schema-name }─▶{ . }┬▶{ pragma-name }┬─────────────────────────────────┬─▶◯
			#              └───────────▶───────────┘                ├─▶{ = }─▶[ pragma-value ]──────▶─┤
			#                                                       └─▶{ ( }─▶[ pragma-value ]─▶{ ) }─┘
		end

		# TODO
		def reindex_stmt
			# ◯─▶{ REINDEX }┬─────────────────────────▶────────────────────────┬─▶◯
			#               ├─▶{ collation-name }────────────────────────────▶─┤
			#               ├─▶{ schema-name }─▶{ . }┬▶┬▶{ table-name }──────▶─┤
			#               └────────▶───────────────┘ └▶{ index-name }──────▶─┘
		end

		# TODO
		def release_stmt
			# ◯─▶{ RELEASE }┬▶{ SAVEPOINT }┬▶{ savepoint-name }─▶◯
			#               └──────▶───────┘
		end

		# TODO
		def rollback_stmt
			#                                          ┌──────▶───────┐
			# ◯─▶{ ROLLBACK }┬▶{ TRANSACTION }┬┬▶{ TO }┴▶{ SAVEPOINT }┴▶{ savepoint-name }┬─▶◯
			#                └───────▶────────┘└─────────────────────▶────────────────────┘
		end

		# TODO
		def savepoint_stmt
			# ◯─▶{ SAVEPOINT }─▶{ savepoint-name }─▶◯
		end

		# TODO
		def select_stmt
			# ◯─▶┬▶[ with-stmt ]─┐
			#    ├───────◀───────┘
			# ┌──┴▶┬─────▶{ SELECT }─┬───────▶──────┬─┬▶[ result-column ]─┐
			# │    │                 ├▶{ DISTINCT }┤ └─────{ , }◀─────────┤
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
			accept :SELECT

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
		end

		# TODO
		def vacuum_stmt
			# ◯─▶{ VACUUUM }┬─────────────────┬▶┬────────────────────────┬─▶◯
			#               └▶{ schema-name }─┘ └▶{ INTO }─▶{ filename }─┘
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
			accept :WITH
			recursive = maybe :RECURSIVE
		end



		# nm ::= ID|INDEXED|JOIN_KW
		# nm ::= STRING
		def identifier
			if one_of? :STRING, :ID, :INDEXED, :JOIN_KW
				value = @lexer.value
				accept current_token
				value
			elsif TOKEN_FALLBACKS[current_token]
				value = @lexer.value
				accept current_token
				value
			else
				error!(current_token, current_value, [:STRING, :ID, :INDEXED, :JOIN_KW])
			end
		end

		# ---

		def accept(*tokens)
			return advance && tokens.first if tokens.size == 1 && tokens.first == current_token

			tokens.each do |token|
				if token == current_token
					advance
				else
					error!(current_token, current_value, tokens)
				end
			end
		end

		def maybe(*tokens)
			return accept(tokens.first) if tokens.size == 1 && tokens.first == current_token

			tokens.all? do |token|
				if token == current_token
					accept token
				else
					false
				end
			end
		end

		def one_of?(*tokens)
			tokens.any? do |token|
				token == current_token
			end
		end

		def optional
			start_index = @current_index
			start_buffer = @peek_buffer.dup
			result = yield
			result
		rescue SyntaxError
			@current_index = start_index
			@peek_buffer = start_buffer
			nil
		end

		def current_token
			ensure_buffer
			@peek_buffer.first
		end

		def peek(n = 1)
			ensure_buffer(n + 1)
			n == 1 ? @peek_buffer[1] : @peek_buffer[1, n]
		end

		def current_value
			@lexer.value_at(@token_index)
		end

		def advance(n = 1)
			ensure_buffer(n)
			@token_index += n
			n.times { @peek_buffer.shift }
			current_token
		end

		def values(n = 1)
			ensure_buffer(n)
			(0...n).map { |i| @lexer.value_at(@token_index + i) }
		end

		def ensure_buffer(size = 1)
			while @peek_buffer.size < size
				@peek_buffer << @lexer.next_token
			end
		end

		def error!(token, value, expected)
			highlight = ' ' * @lexer.token_pos + '^' * (@lexer.cursor - @lexer.token_pos)
			msg = "Unexpected token #{token}[#{value.inspect}] at:\n\t#{@sql}\n\t#{highlight}\n\tExpected one of: #{expected.join(', ')}\n"

			raise SyntaxError, msg
		end
	end
end
