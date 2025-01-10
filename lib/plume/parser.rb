# frozen_string_literal: true

module Plume
	class Parser
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
			require :ALTER, :TABLE

			:alter_table_stmt
		end

		# TODO
		def analyze_stmt
			# ◯─▶{ ANALYZE }─▶┬────────────────────────▶───────────────────────────┬▶◯
			#                 ├▶{ schema-name }──────────────────────────────────▶─┤
			#                 ├▶{ index-or-table-name }──────────────────────────▶─┤
			#                 └▶{ schema-name }─▶{ . }─▶{ table-or-index-name }──▶─┘
			require :ANALYZE

			:analyze_stmt
		end

		# TODO
		def attach_stmt
			# ◯─▶{ ATTACH }─▶┬─▶{ DATABASE }┬▶[ expr ]─▶{ AS }─▶{ schema-name }─▶◯
			#                └───────▶──────┘
			require :ATTACH

			:attach_stmt
		end

		# TODO
		def begin_stmt
			# ◯─▶{ BEGIN }─▶┬─────────────────┬▶┬▶{ TRANSACTION }┬─▶◯
			#               ├▶{ DEFERRED }──▶─┤ └────────▶───────┘
			#               ├▶{ IMMEDIATE }─▶─┤
			#               └▶{ EXCLUSIVE }─▶─┘
			require :BEGIN

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
			require :CREATE

			:create_index_stmt
		end

		def create_table_stmt
			CreateTableStatement()
		end

		def simple_function_invocation
			#                           ┌──{ , }◀─┐
			# ◯─▶{ simple-func }─▶{ ( }┬┴▶[ expr ]┴┬▶{ ) }─▶◯
			#                          ├─────▶─────┤
			#                          └──▶{ * }───┘
			#
			# Built-in scalar functions: (https://www.sqlite.org/lang_corefunc.html)
			#		abs(X), changes(), char(X1,X2,...,XN), coalesce(X,Y,...), concat(X,...), concat_ws(SEP,X,...),
			#		format(FORMAT,...), glob(X,Y), hex(X), ifnull(X,Y), iif(X,Y,Z), instr(X,Y), last_insert_rowid(),
			#		length(X), like(X,Y|X,Y,Z), likelihood(X,Y), likely(X), load_extension(X|X,Y), lower(X),
			#		ltrim(X|X,Y), max(X,Y,...), min(X,Y,...), nullif(X,Y), octet_length(X), printf(FORMAT,...),
			#		quote(X), random(), randomblob(N), replace(X,Y,Z), round(X|X,Y), rtrim(X|X,Y), sign(X),
			#		soundex(X), sqlite_compileoption_get(N), sqlite_compileoption_used(X), sqlite_offset(X),
			#		sqlite_source_id(), sqlite_version(), substr(X,Y|X,Y,Z), substring(X,Y|X,Y,Z), total_changes(),
			#		trim(X|X,Y), typeof(X), unhex(X|X,Y), unicode(X), unlikely(X), upper(X), zeroblob(N)
			# Built-in date and time functions: (https://www.sqlite.org/lang_datefunc.html)
			#		date(time-value, modifier, modifier, ...), time(time-value, modifier, modifier, ...),
			#		datetime(time-value, modifier, modifier, ...), julianday(time-value, modifier, modifier, ...),
			#		unixepoch(time-value, modifier, modifier, ...), strftime(format, time-value, modifier, modifier, ...),
			#		timediff(time-value, time-value)
			# Built-in math functions: (https://www.sqlite.org/lang_mathfunc.html)
			#		acos(X), acosh(X), asin(X), asinh(X), atan(X), atan2(Y,X), atanh(X), ceil(X), ceiling(X), cos(X),
			#		cosh(X), degrees(X), exp(X), floor(X), ln(X), log(B,X), log(X), log10(X), log2(X), mod(X,Y), pi(),
			#		pow(X,Y), power(X,Y), radians(X), sin(X), sinh(X), sqrt(X), tan(X), tanh(X), trunc(X)
			# Built-in JSON functions: (https://www.sqlite.org/json1.html)
			#		json(json), jsonb(json), json_array(value1,value2,...), jsonb_array(value1,value2,...),
			#		json_array_length(json|json,path), json_error_position(json), json_extract(json,path,...),
			#		jsonb_extract(json,path,...), json_insert(json,path,value,...),, jsonb_insert(json,path,value,...),
			#		json_object(label1,value1,...), jsonb_object(label1,value1,...), json_patch(json1,json2),
			#		jsonb_patch(json1,json2), json_pretty(json), json_remove(json,path,...), jsonb_remove(json,path,...),
			#		json_replace(json,path,value,...), jsonb_replace(json,path,value,...), json_set(json,path,value,...),
			#		jsonb_set(json,path,value,...), json_type(json|json,path), json_valid(json|json,flags), json_quote(value)
			func = identifier
			require :LP
			case (func = func.to_sym.upcase)
			when :ABS
				arg = expr
				require :RP
				{ ABS: arg }
			when :ACOS
				arg = expr
				require :RP
				{ ACOS: arg }
			when :ACOSH
				arg = expr
				require :RP
				{ ACOSH: arg }
			when :ASIN
				arg = expr
				require :RP
				{ ASIN: arg }
			when :ASINH
				arg = expr
				require :RP
				{ ASINH: arg }
			when :ATAN
				arg = expr
				require :RP
				{ ATAN: arg }
			when :ATAN2
				args = one_or_more { expr }
				require :RP
				{ ATAN2: args }
			when :ATANH
				arg = expr
				require :RP
				{ ATANH: arg }
			when :CEIL
				arg = expr
				require :RP
				{ CEIL: arg }
			when :CEILING
				arg = expr
				require :RP
				{ CEILING: arg }
			when :CHANGES
				maybe(:STAR)
				require :RP
				:CHANGES
			when :CHAR
				args = one_or_more { expr }
				require :RP
				{ CHAR: args }
			when :COALESCE
				args = one_or_more { expr }
				require :RP
				{ COALESCE: args }
			when :CONCAT
				args = one_or_more { expr }
				require :RP
				{ CONCAT: args }
			when :CONCAT_WS
				args = one_or_more { expr }
				require :RP
				{ CONCAT_WS: args }
			when :COS
				arg = expr
				require :RP
				{ COS: arg }
			when :COSH
				arg = expr
				require :RP
				{ COSH: arg }
			when :DATE
				args = one_or_more { expr }
				require :RP
				{ DATE: args }
			when :DATETIME
				args = one_or_more { expr }
				require :RP
				{ DATETIME: args }
			when :DEGREES
				arg = expr
				require :RP
				{ ACOSH: arg }
			when :EXP
				arg = expr
				require :RP
				{ ACOSH: arg }
			when :FLOOR
				arg = expr
				require :RP
				{ ACOSH: arg }
			when :FORMAT
				args = one_or_more { expr }
				require :RP
				{ FORMAT: args }
			when :GLOB
				args = one_or_more { expr }
				require :RP
				{ GLOB: args }
			when :HEX
				arg = expr
				require :RP
				{ HEX: args }
			when :IFNULL
				args = one_or_more { expr }
				require :RP
				{ IFNULL: args }
			when :IIF
				args = one_or_more { expr }
				require :RP
				{ IIF: args }
			when :INSTR
				args = one_or_more { expr }
				require :RP
				{ INSTR: args }
			when :JULIANDAY
				args = one_or_more { expr }
				require :RP
				{ JULIANDAY: args }
			when :JSON
				arg = expr
				require :RP
				{ JSON: arg }
			when :JSONB
				arg = expr
				require :RP
				{ JSONB: arg }
			when :JSON_ARRAY
				args = one_or_more { expr }
				require :RP
				{ JSON_ARRAY: args }
			when :JSONB_ARRAY
				args = one_or_more { expr }
				require :RP
				{ JSONB_ARRAY: args }
			when :JSON_ARRAY_LENGTH
				args = one_or_more { expr }
				require :RP
				{ JSON_ARRAY_LENGTH: args }
			when :JSON_ERROR_POSITION
				arg = expr
				require :RP
				{ JSON_ERROR_POSITION: arg }
			when :JSON_EXTRACT
				args = one_or_more { expr }
				require :RP
				{ JSON_EXTRACT: args }
			when :JSONB_EXTRACT
				args = one_or_more { expr }
				require :RP
				{ JSONB_EXTRACT: args }
			when :JSON_INSERT
				args = one_or_more { expr }
				require :RP
				{ JSON_INSERT: args }
			when :JSONB_INSERT
				args = one_or_more { expr }
				require :RP
				{ JSONB_INSERT: args }
			when :JSON_OBJECT
				args = one_or_more { expr }
				require :RP
				{ JSON_OBJECT: args }
			when :JSONB_OBJECT
				args = one_or_more { expr }
				require :RP
				{ JSONB_OBJECT: args }
			when :JSON_PATCH
				args = one_or_more { expr }
				require :RP
				{ JSON_PATCH: args }
			when :JSONB_PATCH
				args = one_or_more { expr }
				require :RP
				{ JSONB_PATCH: args }
			when :JSON_PRETTY
				arg = expr
				require :RP
				{ JSON_PRETTY: arg }
			when :JSON_REMOVE
				args = one_or_more { expr }
				require :RP
				{ JSON_REMOVE: args }
			when :JSONB_REMOVE
				args = one_or_more { expr }
				require :RP
				{ JSONB_REMOVE: args }
			when :JSON_REPLACE
				args = one_or_more { expr }
				require :RP
				{ JSON_REPLACE: args }
			when :JSONB_REPLACE
				args = one_or_more { expr }
				require :RP
				{ JSONB_REPLACE: args }
			when :JSON_SET
				args = one_or_more { expr }
				require :RP
				{ JSON_SET: args }
			when :JSONB_SET
				args = one_or_more { expr }
				require :RP
				{ JSONB_SET: args }
			when :JSON_TYPE
				args = one_or_more { expr }
				require :RP
				{ JSON_TYPE: args }
			when :JSON_VALID
				args = one_or_more { expr }
				require :RP
				{ JSON_VALID: args }
			when :JSON_QUOTE
				arg = expr
				require :RP
				{ JSON_QUOTE: arg }
			when :LAST_INSERT_ROWID
				maybe(:STAR)
				require :RP
				:LAST_INSERT_ROWID
			when :LENGTH
				arg = expr
				require :RP
				{ LENGTH: arg }
			when :LIKE
				args = one_or_more { expr }
				require :RP
				{ LIKE: args }
			when :LIKELIHOOD
				args = one_or_more { expr }
				require :RP
				{ LIKELIHOOD: args }
			when :LIKELY
				arg = expr
				require :RP
				{ LIKELY: arg }
			when :LN
				arg = expr
				require :RP
				{ ACOSH: arg }
			when :LOAD_EXTENSION
				args = one_or_more { expr }
				require :RP
				{ LOAD_EXTENSION: args }
			when :LOG
				args = one_or_more { expr }
				require :RP
				{ LOG: args }
			when :LOG10
				arg = expr
				require :RP
				{ LOG10: arg }
			when :LOG2
				arg = expr
				require :RP
				{ LOG2: arg }
			when :LOWER
				arg = expr
				require :RP
				{ LOWER: arg }
			when :LTRIM
				args = one_or_more { expr }
				require :RP
				{ LTRIM: args }
			when :MAX
				args = one_or_more { expr }
				require :RP
				{ MAX: args }
			when :MIN
				args = one_or_more { expr }
				require :RP
				{ MIN: args }
			when :MOD
				args = one_or_more { expr }
				require :RP
				{ MOD: arg }
			when :NULLIF
				args = one_or_more { expr }
				require :RP
				{ NULLIF: args }
			when :OCTET_LENGTH
				arg = expr
				require :RP
				{ OCTET_LENGTH: arg }
			when :PI
				maybe(:STAR)
				require :RP
				:PI
			when :POW
				args = one_or_more { expr }
				require :RP
				{ POW: args }
			when :POWER
				args = one_or_more { expr }
				require :RP
				{ POWER: args }
			when :PRINTF
				args = one_or_more { expr }
				require :RP
				{ PRINTF: args }
			when :QUOTE
				arg = expr
				require :RP
				{ QUOTE: arg }
			when :RADIANS
				arg = expr
				require :RP
				{ RADIANS: arg }
			when :RANDOM
				maybe(:STAR)
				require :RP
				:RANDOM
			when :RANDOMBLOB
				arg = expr
				require :RP
				{ RANDOMBLOB: arg }
			when :REPLACE
				args = one_or_more { expr }
				require :RP
				{ REPLACE: args }
			when :ROUND
				args = one_or_more { expr }
				require :RP
				{ ROUND: args }
			when :RTRIM
				args = one_or_more { expr }
				require :RP
				{ RTRIM: args }
			when :SIGN
				arg = expr
				require :RP
				{ SIGN: arg }
			when :SIN
				arg = expr
				require :RP
				{ SIN: arg }
			when :SINH
				arg = expr
				require :RP
				{ SINH: arg }
			when :SOUNDEX
				arg = expr
				require :RP
				{ SOUNDEX: arg }
			when :SQLITE_COMPILEOPTION_GET
				arg = expr
				require :RP
				{ SQLITE_COMPILEOPTION_GET: arg }
			when :SQLITE_COMPILEOPTION_USED
				arg = expr
				require :RP
				{ SQLITE_COMPILEOPTION_USED: arg }
			when :SQLITE_OFFSET
				arg = expr
				require :RP
				{ SQLITE_OFFSET: arg }
			when :SQLITE_SOURCE_ID
				maybe(:STAR)
				require :RP
				:SQLITE_SOURCE_ID
			when :SQLITE_VERSION
				maybe(:STAR)
				require :RP
				:SQLITE_VERSION
			when :SQRT
				arg = expr
				require :RP
				{ SQRT: arg }
			when :STRFTIME
				args = one_or_more { expr }
				require :RP
				{ STRFTIME: args }
			when :SUBSTR
				args = one_or_more { expr }
				require :RP
				{ SUBSTR: args }
			when :SUBSTRING
				args = one_or_more { expr }
				require :RP
				{ SUBSTRING: args }
			when :TAN
				arg = expr
				require :RP
				{ TAN: arg }
			when :TANH
				arg = expr
				require :RP
				{ TANH: arg }
			when :TIME
				args = one_or_more { expr }
				require :RP
				{ TIME: args }
			when :TIMEDIFF
				args = one_or_more { expr }
				require :RP
				{ TIMEDIFF: args }
			when :TOTAL_CHANGES
				maybe(:STAR)
				require :RP
				:TOTAL_CHANGES
			when :TRIM
				args = one_or_more { expr }
				require :RP
				{ TRIM: args }
			when :TRUNC
				arg = expr
				require :RP
				{ TRUNC: arg }
			when :TYPEOF
				arg = expr
				require :RP
				{ TYPEOF: arg }
			when :UNHEX
				args = one_or_more { expr }
				require :RP
				{ UNHEX: args }
			when :UNICODE
				arg = expr
				require :RP
				{ UNICODE: arg }
			when :UNIXEPOCH
				args = one_or_more { expr }
				require :RP
				{ UNIXEPOCH: args }
			when :UNLIKELY
				arg = expr
				require :RP
				{ UNLIKELY: arg }
			when :UPPER
				arg = expr
				require :RP
				{ UPPER: arg }
			when :ZEROBLOB
				arg = expr
				require :RP
				{ ZEROBLOB: arg }
			else
				args = one_or_more { expr }
				require :RP
				{ FN: { func => args } }
			end
		end

		def aggregate_function_invocation
			#                              ┌─▶{ DISTINCT }─▶┐ ┌──{ , }◀─┐
			# ◯─▶{ aggregate-func }─▶{ ( }─┼────────────────┴▶┴▶[ expr ]┼───────────┬─┬─▶{ ) }┬─────────▶─────────┬─▶◯
			#                              │ ┌──────────────────────────┘           │ │       └▶[ filter-clause ]─┘
			#                              │ └▶{ ORDER }─▶{ BY }┬▶[ ordering-term ]─┤ │
			#                              │                    └───────{ , }◀──────┘ │
			#                              └─────────────────┬▶{ * }┬▶────────────────┘
			#                                                └───▶──┘
			#
			# Built-in aggregate functions: (https://www.sqlite.org/lang_aggfunc.html)
			#		avg(X), count(*), count(X), group_concat(X|X,Y), max(X), min(X), string_agg(X,Y), sum(X), total(X)
			func = identifier
			require :LP

			args = nil
			if maybe :DISTINCT
				exprs = one_or_more { expr }
				if maybe_all :ORDER, :BY
					terms = one_or_more { ordering_term }
					args = { DISTINCT: exprs << { ORDER_BY: terms } }
				else
					args = { DISTINCT: exprs }
				end
			elsif maybe :STAR
				args = :*
			elsif (e = optional { expr })
				exprs = one_or_more(given: e) { expr }
				if maybe_all :ORDER, :BY
					terms = one_or_more { ordering_term }
					args = exprs << { ORDER_BY: terms }
				else
					args = exprs
				end
			elsif :RP == current_token
				# no-op
			else
				expected!(:DISTINCT, :STAR, :RP, "expr")
			end

			key = nil
			case (func = func.to_sym.upcase)
			when :AVG
				key = { AVG: args }
			when :COUNT
				key = { COUNT: args }
			when :GROUP_CONCAT
				key = { GROUP_CONCAT: args }
			when :MAX
				key = { MAX: args }
			when :MIN
				key = { MIN: args }
			when :STRING_AGG
				key = { STRING_AGG: args }
			when :SUM
				key = { SUM: args }
			when :TOTAL
				key = { TOTAL: args }
			else
				key = { FN: { func => args } }
			end
			require :RP

			if (filter = optional { filter_clause })
				{ key => filter }
			else
				key
			end
		end

		def window_function_invocation
			#                           ┌──{ , }◀─┐
			# ◯─▶{ window-func }─▶{ ( }┬┴▶[ expr ]┴┬▶{ ) }┬───────────────────────┬▶{ OVER }┬─▶[ window-defn ]───┬─▶◯
			#                          ├─────▶─────┤      └──▶[ filter-clause ]───┘         └─▶{ window-name }───┘
			#                          └──▶{ * }───┘
			# Built-in window functions: (https://www.sqlite.org/windowfunctions.html)
			#		row_number(), rank(), dense_rank(), percent_rank(), cume_dist(), ntile(N), lag(X|X,Y|X,Y,Z),
			#		lead(X|X,Y|X,Y,Z), first_value(X), last_value(X), nth_value(X,N)
			# Built-in aggregate functions: (https://www.sqlite.org/lang_aggfunc.html)
			#		avg(X), count(*|X), group_concat(X|X,Y), max(X), min(X), string_agg(X,Y), sum(X), total(X)
			func = identifier
			require :LP
			key = nil
			case (func = func.to_sym.upcase)
			when :ROW_NUMBER
				maybe(:STAR)
				require :RP
				key = :ROW_NUMBER
			when :RANK
				maybe(:STAR)
				require :RP
				key = :RANK
			when :DENSE_RANK
				maybe(:STAR)
				require :RP
				key = :DENSE_RANK
			when :PERCENT_RANK
				maybe(:STAR)
				require :RP
				key = :PERCENT_RANK
			when :CUME_DIST
				maybe(:STAR)
				require :RP
				key = :CUME_DIST
			when :NTILE
				arg = expr
				require :RP
				key = { NTILE: arg }
			when :LAG
				args = one_or_more { expr }
				require :RP
				key = { LAG: args }
			when :LEAD
				args = one_or_more { expr }
				require :RP
				key = { LEAD: args }
			when :FIRST_VALUE
				arg = expr
				require :RP
				key = { FIRST_VALUE: arg }
			when :LAST_VALUE
				arg = expr
				require :RP
				key = { LAST_VALUE: arg }
			when :NTH_VALUE
				args = one_or_more { expr }
				require :RP
				key = { NTH_VALUE: args }
			when :AVG
				arg = expr
				require :RP
				key = { AVG: arg }
			when :COUNT
				arg = maybe(:STAR) ? :* : expr
				require :RP
				key = { COUNT: arg }
			when :GROUP_CONCAT
				args = one_or_more { expr }
				require :RP
				key = { GROUP_CONCAT: args }
			when :MAX
				arg = expr
				require :RP
				key = { MAX: arg }
			when :MIN
				arg = expr
				require :RP
				key = { MIN: arg }
			when :STRING_AGG
				args = one_or_more { expr }
				require :RP
				key = { STRING_AGG: args }
			when :SUM
				arg = expr
				require :RP
				key = { SUM: arg }
			when :TOTAL
				arg = expr
				require :RP
				key = { TOTAL: arg }
			else
				args = one_or_more { expr }
				require :RP
				key = { FN: { func => args } }
			end

			filter = optional { filter_clause }
			require :OVER
			window = (:LP == current_token) ? window_defn : identifier

			{ key => { OVER: window }.merge!(filter || {}) }
		end

		def filter_clause
			# ◯─▶{ FILTER }─▶{ ( }─▶{ WHERE }─▶[ expr ]─▶{ ) }─▶◯
			require_all :FILTER, :LP, :WHERE
			condition = expr
			require :RP

			{ FILTER: condition }
		end

		def window_defn
			# ◯─▶{ ( }┬───────────────────────┐
			#         └─▶{ base-window-name }─┤
			#      ┌──────────────────────────┘
			#      ├─▶{ PARTITION }─▶{ BY }┬[ expr ]┐
			#      │                       └─{ , }◀─┤
			#      ├────────────────────────────────┘
			#      ├─▶{ ORDER }─▶{ BY }┬[ ordering-term ]┐
			#      │                   └──────{ , }◀─────┤
			#      ├─────────────────────────────────────┘
			#      ├─▶[ frame-spec ]┬─▶──────────────────{ ) }─▶◯
			#      └─────────▶──────┘
			require :LP
			name = optional { identifier }
			partition_by = {}
			if maybe_all :PARTITION, :BY
				partition_by = { PARTITION_BY: one_or_more { expr } }
			end
			order_by = {}
			if maybe_all :ORDER, :BY
				order_by = { ORDER_BY: one_or_more { ordering_term } }
			end
			frame = optional { frame_spec }
			require :RP

			if name.nil? && partitions.nil? && orders.nil? && frame.nil?
				{ OVER: [] }
			elsif name && partitions.nil? && orders.nil? && frame.nil?
				{ OVER: Ref[name] }
			elsif name
				{ OVER: [Ref[name], partition_by.merge!(order_by)] }
			else
				{ OVER: partition_by.merge!(order_by) }
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
						starting = :UNBOUNDED_PRECEDING
					elsif maybe_all :CURRENT, :ROW
						precedence = 3
						starting = :CURRENT_ROW
					elsif (e = optional { expr })
						if maybe :PRECEDING
							precedence = 2
							starting = { PRECEDING: e }
						elsif maybe :FOLLOWING
							precedence = 4
							starting = { FOLLOWING: e }
						else
							expected!(:PRECEDING, :FOLLOWING)
						end
					else
						expected!("UNBOUNDED PRECEDING", "CURRENT ROW", "expr")
					end
					require :AND
					if maybe_all :CURRENT, :ROW
						expected!("UNBOUNDED FOLLOWING", "expr") if 3 < precedence
						ending = :CURRENT_ROW
					elsif maybe_all :UNBOUNDED, :FOLLOWING
						ending = :UNBOUNDED_FOLLOWING
					elsif (e = optional { expr })
						if maybe :PRECEDING
							expected!("CURRENT ROW", "UNBOUNDED FOLLOWING", "expr") if 2 < precedence
							ending = { PRECEDING: e }
						elsif maybe :FOLLOWING
							expected!("UNBOUNDED FOLLOWING") if 4 < precedence
							ending = { FOLLOWING: e }
						else
							expected!(:PRECEDING, :FOLLOWING)
						end
					else
						expected!("CURRENT ROW", "UNBOUNDED FOLLOWING", "expr")
					end
					boundary = { BETWEEN: [starting, ending] }
				elsif maybe_all :UNBOUNDED, :PRECEDING
					boundary = :UNBOUNDED_PRECEDING
				elsif maybe_all :CURRENT, :ROW
					boundary = :CURRENT_ROW
				elsif (e = optional { expr })
					require :PRECEDING
					boundary = { PRECEDING: e }
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

				if exclude && Hash === boundary
					{ type => boundary.merge!({ EXCLUDE: exclude }) }
				elsif exclude
					{ type => [boundary, { EXCLUDE: exclude }] }
				else
					{ type => boundary }
				end
			else
				expected!(:RANGE, :ROWS, :GROUPS)
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
				direction = require current_token
			end
			if maybe :NULLS
				nulls = maybe(:FIRST) || maybe(:LAST)
			end

			key = collation ? [e, collation] : e
			return { key => direction } unless nulls

			value = (nulls == :FIRST) ? [nil, direction] : [direction, nil]
			{ key => value }
		end

		def raise_function
			# ◯─▶{ RAISE }─▶{ ( }┬─▶{ IGNORE }────────────────────▶─────────┬▶{ ) }──▶◯
			#                    ├─▶{ ROLLBACK }─┬▶{ , }─▶{ error-message }─┘
			#                    ├─▶{ ABORT }──▶─┤
			#                    └─▶{ FAIL }───▶─┘
			require_all :RAISE, :LP
			if maybe :IGNORE
				require :RP
				{ RAISE: :IGNORE }
			elsif maybe :ROLLBACK
				require :COMMA
				error_message = identifier
				require :RF
				{ RAISE: { ROLLBACK: error_message } }
			elsif maybe :ABORT
				require :COMMA
				error_message = identifier
				require :RF
				{ RAISE: { ABORT: error_message } }
			elsif maybe :FAIL
				require :COMMA
				error_message = identifier
				require :RF
				{ RAISE: { FAIL: error_message } }
			else
				expected!(:IGNORE, :ROLLBACK, :ABORT, :FAIL)
			end
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
			if one_of? :STRING, :ID
				value = current_value
				require current_token
				value
			elsif TOKEN_FALLBACKS[current_token]
				value = @lexer.value
				require current_token
				value
			else
				expected!(:STRING, :ID, *TOKEN_FALLBACKS.reject { |_, v| v.nil? }.keys)
			end
		end

		def blob_literal
			if current_token == :BLOB
				value = current_value
				require current_token
				value
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
			return nil if maybe :NULL
			return true if current_token == :ID && current_value.upcase == "TRUE" && require(:ID)
			return false if current_token == :ID && current_value.upcase == "FALSE" && require(:ID)
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
			foreign_table = identifier
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
				meta[:MATCH] = identifier
			end
			if maybe_all :DEFERRABLE, :INITIALLY, :DEFERRED
				meta[:DEFERRED] = true
			elsif maybe :DEFERRABLE
				meta[:DEFERRED] = false
			elsif maybe_all :NOT, :DEFERRABLE
				meta[:DEFERRED] = false
			elsif maybe_all :DEFERRABLE, :INITIALLY, :IMMEDIATE
				meta[:DEFERRED] = false
			elsif maybe_all :NOT, :DEFERRABLE, :INITIALLY, :IMMEDIATE
				meta[:DEFERRED] = false
			elsif maybe_all :NOT, :DEFERRABLE, :INITIALLY, :DEFERRED
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
			# └─▶{ FOR }─▶{ EACH }─▶{ ROW }─┬─┴▶{ WHEN }─▶[ expr ]─┐
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
			require :SELECT

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
			require :WITH
			recursive = maybe :RECURSIVE
		end

		# nm ::= ID|INDEXED|JOIN_KW
		# nm ::= STRING
		def identifier
			if one_of? :STRING, :ID, :INDEXED, :CROSS, :FULL, :INNER, :LEFT, :NATURAL, :OUTER, :RIGHT
				value = current_value
				require current_token
				value
			elsif TOKEN_FALLBACKS[current_token]
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
				advance && token
			else
				expected!(token)
			end
		end

		def maybe(token)
			advance && token if token == current_token
		end

		def require_all(*tokens)
			# save one allocation as `Array#each` (at least up to Ruby 3.3) actually allocates one object
			i, len = 0, tokens.length
			while i < len
				token = tokens[i]
				if token == current_token
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
			peek_buffer = ensure_buffer(len)
			while i < len
				if tokens[i] != peek_buffer[i]
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
			start_index = @current_index
			start_buffer = @peek_buffer.dup
			yield
		rescue SyntaxError
			@current_index = start_index
			@peek_buffer = start_buffer
			nil
		end

		def one_or_more(sep: :COMMA, given: nil)
			[].tap do |a|
				a << (given || yield)
				if sep
					a << yield while maybe sep
				else
					while (x = optional { yield })
						a << x
					end
				end
			end
		end

		def zero_or_more(sep: :COMMA)
			[].tap do |a|
				if sep
					a << yield while maybe sep
				else
					while (x = optional { yield })
						a << x
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

		def current_token
			ensure_buffer
			@peek_buffer.first
		end

		def peek(n = 1)
			ensure_buffer(n + 1)
			(n == 1) ? @peek_buffer[1] : @peek_buffer[1, n]
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
			peek_buffer = @peek_buffer
			while peek_buffer.size < size
				peek_buffer << @lexer.next_token
			end
			peek_buffer
		end

		def expected!(*expected)
			error!(current_token, current_value, expected)
		end

		def error!(token, value, expected)
			# TODO: we should handle multi-line sql highlighting
			highlight = (" " * @lexer.token_pos) + ("^" * (@lexer.cursor - @lexer.token_pos))
			msg = "Unexpected token #{token}[#{value.inspect}] at:\n  #{@sql.strip}\n  #{highlight}\n  Expected one of: #{expected.join(", ")}\n"

			raise SyntaxError, msg
		end
	end
end
