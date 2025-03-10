# frozen_string_literal: true

module Plume
	class Parser
		# https://www.sqlite.org/syntaxdiagrams.html
		class ErrorMessage
			attr_reader :msg

			def initialize(msg)
				@msg = msg
			end
		end

		# see: https://github.com/sqlite/sqlite/blob/master/src/parse.y#L255-L283
		TOKEN_FALLBACKS = Set[
			:EXPLAIN,
			:QUERY,
			:PLAN,
			:BEGIN,
			:DEFERRED,
			:IMMEDIATE,
			:EXCLUSIVE,
			:END,
			:ROLLBACK,
			:SAVEPOINT,
			:RELEASE,
			:IF,
			:TEMP,
			:TEMPORARY,
			:WITHOUT,
			:ABORT,
			:ACTION,
			:AFTER,
			:ANALYZE,
			:ASC,
			:ATTACH,
			:BEFORE,
			:BY,
			:CASCADE,
			:CAST,
			:CONFLICT,
			:DATABASE,
			:DESC,
			:DETACH,
			:EACH,
			:FAIL,
			:MATCH,
			:REGEXP,
			:GLOB,
			:LIKE,
			:ROWID,
			:STRICT,
			:COLUMN,
			:DO,
			:FOR,
			:IGNORE,
			:INITIALLY,
			:INSTEAD,
			:NO,
			:KEY,
			:OF,
			:OFFSET,
			:PRAGMA,
			:RAISE,
			:RECURSIVE,
			:REPLACE,
			:RESTRICT,
			:ROW,
			:ROWS,
			:TRIGGER,
			:VACUUM,
			:VIEW,
			:VIRTUAL,
			:WITH,
			:NULLS,
			:FIRST,
			:LAST,
			:CURRENT,
			:FOLLOWING,
			:PARTITION,
			:PRECEDING,
			:RANGE,
			:UNBOUNDED,
			:EXCLUDE,
			:GROUPS,
			:OTHERS,
			:TIES,
			:GENERATED,
			:ALWAYS,
			:MATERIALIZED,
			:REINDEX,
			:RENAME,
			:CTIME_KW,
		].freeze

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

		private

		def sql_stmt_list
			# Relevant `parse.y` grammar rules:
			#   input ::= cmdlist
			#   cmdlist ::= cmdlist ecmd | ecmd
			#   ecmd ::= SEMI | cmdx SEMI | explain cmdx SEMI
			#
			# Syntax diagram:
			#     ┌──────{ ; }◀─────┐
			#   ◯─┴┬─▶[ sql-stmt ]─┬┴─▶◯
			#      └───────▶───────┘
			#
			# Simplified grammar:
			#   SEMI* [sql_stmt SEMI]*
			#
			# Relevant SQLite documentation:
			#   - https://www.sqlite.org/lang.html
			#
			# A `sql_stmt_list` is zero or more statements,
			# where a `;` is the statement separator,
			# but an empty statement is allowed.
			#
			[].tap do |stmts|
				until current_token.nil?
					maybe :SEMI
					stmts << sql_stmt if current_token
					maybe :SEMI
				end
			end
		end

		def sql_stmt
			#
				# Relevant `parse.y` grammar rules:
				#   ecmd ::= SEMI | cmdx SEMI | explain cmdx SEMI
				#   explain ::= EXPLAIN | EXPLAIN QUERY PLAN
				#   cmdx ::= cmd
				#
				# Syntax diagram:
				#   ◯─┬─────────────┬▶─────────────────────┬─┬─▶[ alter-table-stmt ]──────────▶─┬─▶◯
				#     └─{ EXPLAIN }─┴─▶{ QUERY }─▶{ PLAN }─┘ ├─▶[ analyze-stmt ]──────────────▶─┤
				#                                            ├─▶[ attach-stmt ]───────────────▶─┤
				#                                            ├─▶[ begin-stmt ]────────────────▶─┤
				#                                            ├─▶[ commit-stmt ]───────────────▶─┤
				#                                            ├─▶[ create-index-stmt ]─────────▶─┤
				#                                            ├─▶[ create-table-stmt ]─────────▶─┤
				#                                            ├─▶[ create-trigger-stmt ]───────▶─┤
				#                                            ├─▶[ create-view-stmt ]──────────▶─┤
				#                                            ├─▶[ create-virtual-table-stmt ]─▶─┤
				#                                            ├─▶[ delete-stmt ]───────────────▶─┤
				#                                            ├─▶[ detach-stmt ]───────────────▶─┤
				#                                            ├─▶[ drop-index-stmt ]───────────▶─┤
				#                                            ├─▶[ drop-table-stmt ]───────────▶─┤
				#                                            ├─▶[ drop-trigger-stmt ]─────────▶─┤
				#                                            ├─▶[ drop-view-stmt ]────────────▶─┤
				#                                            ├─▶[ insert-stmt ]───────────────▶─┤
				#                                            ├─▶[ pragma-stmt ]───────────────▶─┤
				#                                            ├─▶[ reindex-stmt ]──────────────▶─┤
				#                                            ├─▶[ release-stmt ]──────────────▶─┤
				#                                            ├─▶[ rollback-stmt ]─────────────▶─┤
				#                                            ├─▶[ savepoint-stmt ]────────────▶─┤
				#                                            ├─▶[ select-stmt ]───────────────▶─┤
				#                                            ├─▶[ update-stmt ]───────────────▶─┤
				#                                            └─▶[ vacuum-stmt ]───────────────▶─┘
				# Simplified grammar:
				#   [EXPLAIN [QUERY PLAN]] stmt
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/lang_explain.html
				#   - https://www.sqlite.org/eqp.html
				#   - https://www.sqlite.org/opcode.html
				#
				# A `sql_stmt` is a single SQL statement, optionally preceded by one of two different
				# explanation prefixes. A simple `EXPLAIN` prefix requests the bytecode instructions,
				# while `EXPLAIN QUERY PLAN` requests the query plan.
				#
				# This method doesn't consume tokens associated with the statements so that each
				# statement method can independently consume the tokens it needs.
			#
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
						expected! :TABLE, :TRIGGER, :VIEW
					end
				else
					expected! :INDEX, :TABLE, :TRIGGER, :VIEW, :VIRTUAL, :UNIQUE, :TEMP, :TEMPORARY
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

		def _consume_all
			require current_token until current_token.nil?

			__callee__
		end
		alias_method :alter_table_stmt, :_consume_all
		alias_method :analyze_stmt, :_consume_all
		alias_method :attach_stmt, :_consume_all
		alias_method :begin_stmt, :_consume_all
		alias_method :commit_stmt, :_consume_all
		alias_method :create_index_stmt, :_consume_all
		alias_method :create_trigger_stmt, :_consume_all
		alias_method :create_view_stmt, :_consume_all
		alias_method :create_virtual_table_stmt, :_consume_all
		alias_method :delete_stmt, :_consume_all
		alias_method :detach_stmt, :_consume_all
		alias_method :drop_index_stmt, :_consume_all
		alias_method :drop_table_stmt, :_consume_all
		alias_method :drop_trigger_stmt, :_consume_all
		alias_method :drop_view_stmt, :_consume_all
		alias_method :insert_stmt, :_consume_all
		alias_method :pragma_stmt, :_consume_all
		alias_method :reindex_stmt, :_consume_all
		alias_method :release_stmt, :_consume_all
		alias_method :rollback_stmt, :_consume_all
		alias_method :savepoint_stmt, :_consume_all
		alias_method :select_stmt, :_consume_all
		alias_method :update_stmt, :_consume_all
		alias_method :vacuum_stmt, :_consume_all
		alias_method :with_stmt, :_consume_all

		# ---------- Statements ----------

		def create_table_stmt
			#
				# Relevant `parse.y` grammar rules:
				#   cmd ::= create_table create_table_args
				#   create_table ::= createkw temp TABLE ifnotexists nm dbnm
				#   create_table_args ::= LP columnlist conslist_opt RP table_option_set | AS select
				#   createkw ::= CREATE
				#   temp ::= . | TEMP
				#   ifnotexists ::= . | IF NOT EXISTS
				#   columnlist ::= columnlist COMMA columnname carglist
				#   nm ::= idj | STRING
				#   dbnm ::= . | DOT nm
				#
				# Syntax diagram:
				#   ◯─▶{ CREATE }┬───────▶──────┬▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
				#                ├▶{ TEMP }─────┤          │                             │
				#                └▶{ TEMPORARY }┘          │                             │
				#   ┌─────────────────────◀────────────────┴──────────────────◀──────────┘
				#   ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }┬───────▶{ AS }─▶[ select-stmt ]───▶─────┐
				#   └────────▶────────────────┘               │                                        │
				#   ┌────────────────────◀────────────────────┘                     ┌────────▶─────────┼─▶◯
				#   └▶{ ( }─┬▶[ column-def ]─┬▶┬─────────────────────────────┬▶{ ) }┴▶[ table-options ]┘
				#           └─────{ , }◀─────┘ └[ table-constraint ]◀─{ , }◀─┘
				#
				# Simplified grammar:
				#   CREATE [TEMP] TABLE [IF NOT EXISTS] name [DOT name] (
				#     LP column_def [, column_def]* [table_constraint [, table_constraint]*] RP [table_options]
				#     | AS select_stmt
				#   )
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/lang_createtable.html
				#
				# A `create_table_stmt` creates a table.
			#
			create_kw         = require      :CREATE
			temp_kw           = maybe_one_of :TEMP, :TEMPORARY
			table_kw          = require      :TABLE
			if_not_exists_kw  = maybe_all_of :IF, :NOT, :EXISTS
			table_name        =              table_name()

			if maybe :AS
				as_select = select_stmt
				CreateTableStatement.new(
					schema_name:,
					table_name:,
					temporary: (true if temporary),
					if_not_exists: (true if if_not_exists),
					select_statement: as_select
				)
			elsif (columns_lp = maybe          :LP)
				columns         = require_some { column_def }
				# inlined `table_constraint`
				constraints     = maybe_some(sep: [:COMMA, nil].freeze) do
					#
						# Relevant `parse.y` grammar rules:
						#   conslist_opt ::= . | COMMA conslist.
						#   conslist ::= conslist tconscomma tcons | tcons
						#   tconscomma ::= . | COMMA
						#   tcons ::= CONSTRAINT nm |
						#             PRIMARY KEY LP sortlist autoinc RP onconf |
						#             UNIQUE LP sortlist RP onconf |
						#             CHECK LP expr RP onconf |
						#             FOREIGN KEY LP eidlist RP REFERENCES nm eidlist_opt refargs defer_subclause_opt
						#
						# Syntax diagram:
						#   ◯─▶┬▶{ CONSTRAINT }─▶{ name }─┐
						#      ├─────────────◀────────────┘
						#      ├─▶{ PRIMARY }─▶{ KEY }───▶{ ( }┬▶[ indexed-column ]┬┬▶{ AUTOINCREMENT }┬▶{ ) }─▶[ conflict-clause ]───┬─▶◯
						#      │                               └───────{ , }◀──────┘└────────▶─────────┘                              │
						#      ├─▶{ UNIQUE }──▶{ ( }┬▶[ indexed-column ]┬▶{ ) }─▶[ conflict-clause ]────────────────────────────────▶─┤
						#      │                    └───────{ , }◀──────┘                                                             │
						#      ├─▶{ CHECK }─▶{ ( }─▶[ expr ]─▶{ ) }─────────────────────────────────────────────────────────────────▶─┤
						#      └─▶{ FOREIGN }─▶{ KEY }─▶{ ( }┬▶[ indexed-column ]┬▶{ ) }─▶[ foreign-key-clause ]────────────────────▶─┘
						#                                    └──────{ , }◀───────┘
						#
						# Simplified grammar:
						#
						# Relevant SQLite documentation:
						#   - https://www.sqlite.org/syntax/table-constraint.html
						#
						# A set of SQL constraints for each table.
						# SQLite supports UNIQUE, NOT NULL, CHECK and FOREIGN KEY constraints.
					#
					if (constraint_kw     = maybe :CONSTRAINT)
						constraint_name     = name
					end

					if    (unique_kw      = maybe          :UNIQUE)
						unique_lp           = require        :LP
						unique_columns      = require_some { indexed_column }
						unique_rp           = require        :RP
						on_conflict         = maybe        { conflict_clause }

						UniqueTableConstraint.new(
							full_source:     @lexer.sql,
							constraint_kw:   Token::Keyword(constraint_kw),
							name_tk:         Token::Identifier(constraint_name),
							unique_kw:       Token::Keyword(unique_kw),
							unique_lp:       Token::Punctuation(unique_lp),
							columns:         unique_columns,
							unique_rp:       Token::Punctuation(unique_rp),
							conflict_clause: on_conflict,
						)
					elsif (check_kw       = maybe          :CHECK)
						check_lp            = require        :LP
						check               =                expression
						check_rp            = require        :RP

						CheckTableConstraint.new(
							full_source:     @lexer.sql,
							constraint_kw:   Token::Keyword(constraint_kw),
							name_tk:         Token::Identifier(constraint_name),
							check_kw:        Token::Keyword(check_kw),
							check_lp:        Token::Punctuation(check_lp),
							expression:      check,
							check_rp:        Token::Punctuation(check_rp),
						)
					elsif (primary_key_kw = maybe_all_of   :PRIMARY, :KEY)
						primary_key_lp      = require        :LP
						primary_key_columns = require_some { indexed_column }
						autoincrement_kw    = maybe          :AUTOINCREMENT
						primary_key_rp      = require        :RP
						on_conflict         = maybe        { conflict_clause }

						PrimaryKeyTableConstraint.new(
							full_source:      @lexer.sql,
							constraint_kw:    Token::Keyword(constraint_kw),
							name_tk:          Token::Identifier(constraint_name),
							primary_key_kw:   Token::Keyword(primary_key_kw),
							primary_key_lp:   Token::Punctuation(primary_key_lp),
							columns:          primary_key_columns,
							autoincrement_kw: Token::Keyword(autoincrement_kw),
							primary_key_rp:   Token::Punctuation(primary_key_rp),
							conflict_clause:  on_conflict,
						)
					elsif (foreign_key_kw = maybe_all_of   :FOREIGN, :KEY)
						foreign_key_lp      = require        :LP
						foreign_key_columns = require_some { indexed_column }
						foreign_key_rp      = require        :RP
						clause              =                foreign_key_clause

						ForeignKeyTableConstraint.new(
							full_source:        @lexer.sql,
							constraint_kw:      Token::Keyword(constraint_kw),
							name_tk:            Token::Identifier(constraint_name),
							foreign_key_kw:     Token::Keyword(foreign_key_kw),
							foreign_key_lp:     Token::Punctuation(foreign_key_lp),
							columns:            foreign_key_columns,
							foreign_key_rp:     Token::Punctuation(foreign_key_rp),
							foreign_key_clause: clause,
						)
					else
						if constraint_name
							NoOpTableConstraint.new(
								full_source:   @lexer.sql,
								constraint_kw: Token::Keyword(constraint_kw),
								name_tk:       Token::Identifier(constraint_name),
							)
						else
							expected!(:PRIMARY, :UNIQUE, :CHECK, :FOREIGN)
						end
					end
				end
				columns_rp      = require        :RP
				# inlined `table_options`
				options         = maybe do
					#
						# Relevant `parse.y` grammar rules:
						#   table_option_set ::= . | table_option | table_option_set COMMA table_option
						#   table_option ::= WITHOUT nm  // nm must be "ROWID"
						#   table_option ::= nm          // nm must be "STRICT"
						#
						# Syntax diagram:
						#       ┌─▶{ WITHOUT }─▶{ ROWID }─┐
						#   ◯─┬─┤                         ├─┬─▶◯
						#     │ └─▶{ STRICT }─────────────┘ │
						#     └──────◀───────────────{ , }◀─┘
						#
						# Simplified grammar:
						#   [WITHOUT ROWID | STRICT] [, [WITHOUT ROWID | STRICT]]*
						#
						# Relevant SQLite documentation:
						#   - https://www.sqlite.org/syntax/table-options.html
						#   - https://www.sqlite.org/withoutrowid.html
						#   - https://www.sqlite.org/stricttables.html
						#
						# Whether the table is a WITHOUT ROWID table.
						# Whether the table is subject to STRICT type checking.
					#
					require_some do
						if maybe(:STRICT)
							StrictTableOption.new
						elsif maybe_all_of(:WITHOUT, :ROWID)
							WithoutRowidTableOption.new
						else
							expected!(:STRICT, :WITHOUT)
						end
					end
				end

				CreateTableStatement.new(
					full_source:      @lexer.sql,
					create_kw:        Token::Keyword(create_kw),
					temp_kw:          Token::Keyword(temp_kw),
					table_kw:         Token::Keyword(table_kw),
					if_not_exists_kw: Token::Keyword(if_not_exists_kw),
					table:            table_name,
					columns_lp:       Token::Punctuation(columns_lp),
					columns:          columns,
					columns_rp:       Token::Punctuation(columns_rp),
					options:          options,
					constraints:      constraints,
				)
			else
				expected!(:AS, :LP)
			end
		end

		# ---------- Clauses ----------

		def expression(min_precedence = 0)
			#
				# Relevant `parse.y` grammar rules:
				#
				# Syntax diagram:
				#   ◯┬─▶[ literal-value ]───────────────────────────────────────────────────────────────────────────────────┬─▶◯
				#    ├─▶{ bind-parameter }────────────────────────────────────────────────────────────────────────────────▶─┤
				#    ├────────────────────────┬──────────────────────┐                                                      │
				#    ├─▶{ schema-name }─▶{ . }┴▶{ table-name }─▶{ . }┴▶{ column-name }────────────────────────────────────▶─┤
				#    ├─▶{ unary-operator }─▶[ expr ]──────────────────────────────────────────────────────────────────────▶─┤
				#    ├─▶[ expr ]─▶{ binary-operator }─▶[ expr ]───────────────────────────────────────────────────────────▶─┤
				#    ├─▶{ function-name }─▶{ ( }─▶[ function-arguments ]─▶{ ) }┬───────────────────┬┬─────────────────────▶─┤
				#    │       ┌──{ , }◀─┐                                       └▶[ filter-clause ]─┘└▶[ over-clause ]─────▶─┤
				#    ├─▶{ ( }┴▶[ expr ]┴▶{ ) }────────────────────────────────────────────────────────────────────────────▶─┤
				#    ├─▶{ CAST }─▶{ ( }─▶[ expr ]─▶{ AS }─▶[ type-name ]─▶{ ) }───────────────────────────────────────────▶─┤
				#    ├─▶[ expr ]─▶{ COLLATE }─▶{ collation-name }─────────────────────────────────────────────────────────▶─┤
				#    ├─▶[ expr ]┬▶{ NOT }┬┬▶{ LIKE }─────▶[ expr ]─┬────▶────────────────┬▶┬──────────────────────────────▶─┤
				#    │          └────▶───┘├▶{ GLOB }───┐           └▶{ ESCAPE }─▶[ expr ]┘ │                                │
				#    │                    ├▶{ REGEXP }─┼─▶[ expr ]────────────▶────────────┘                                │
				#    │                    └▶{ MATCH }──┘                                                                    │
				#    ├─▶[ expr ]┬▶{ ISNULL }───────┬──────────────────────────────────────────────────────────────────────▶─┤
				#    │          ├▶{ NOTNULL }──────┤                                                                        │
				#    │          └▶{ NOT }─▶{ NULL }┘                                                                        │
				#    ├─▶[ expr ]─▶{ IS }┬▶{ NOT }┬┬▶{ DISTINCT }─▶{ FROM }┬▶[ expr ]──────────────────────────────────────▶─┤
				#    │                  └────▶───┘└────────────▶──────────┘                                                 │
				#    ├─▶[ expr ]┬▶{ NOT }┬▶{ BETWEEN }─▶[ expr ]─▶{ AND }─▶[ expr ]───────────────────────────────────────▶─┤
				#    │          └────▶───┘               ┌─────────────────┐                                                │
				#    ├─▶[ expr ]┬▶{ NOT }┬▶{ IN }┬▶{ ( }─┼▶[ select-stmt ]─┼▶{ ) }────────────────────────────────────────▶─┤
				#    │          └────▶───┘       │       └─┬──▶[ expr ]──┬─┘                                                │
				#    │                           │         └────{ , }◀───┘ ┌▶{ table-name }───────────────────────────────▶─┤
				#    │                           ├────────────────────────┐│                           ┌──{ , }──┐          │
				#    │                           └─▶{ schema-name }─▶{ . }┴┴▶{ table-function }─▶{ ( }┬┴▶[ expr ]┴┬▶{ ) }─▶─┤
				#    ├────▶────┬───────────┐                                                          └─────▶─────┘         │
				#    ├─▶{ NOT }┴▶{ EXISTS }┴▶{ ( }─▶[ select-stmt ]─▶{ ) }────────────────────────────────────────────────▶─┤
				#    ├─▶{ CASE }┬▶[ expr ]┬┬▶{ WHEN }─▶[ expr ]─▶{ THEN }─▶[ expr ]┬┬▶{ ELSE }─▶[ expr ]┬▶{ END }─────────▶─┤
				#    │          └─────▶───┘└────────────────◀──────────────────────┘└─────────▶─────────┘                   │
				#    └─▶[ raise-function ]────────────────────────────────────────────────────────────────────────────────▶─┘
				#
				# Simplified grammar:
				#
				# Relevant SQLite documentation:
				#   -
				#
				# [description]
			#

			left = basic_expression

			while (operator = current_token)
				operator_precedence = OPERATOR_PRECEDENCE[operator] || -1
				break if operator_precedence < min_precedence
				next_precedence = operator_precedence + 1

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
						# elsif (s = maybe { select_stmt })
						# 	require :RP

						# 	return expression_node.new(
						# 		member: left,
						# 		collection: s
						# 	)
						# :nocov:
						elsif (e = maybe { expression(next_precedence) })
							exprs = require_some(given: e) { expression(next_precedence) }
							require :RP

							return expression_node.new(
								member: left,
								collection: exprs
							)
						else
							expected!(:RP, "select-stmt", "expr")
						end
					elsif (ref = maybe { identifier })
						if maybe :DOT
							schema_name = ref
							name = identifier

							if maybe :LP
								function_name = name
								arguments = maybe_som { expression(next_precedence) }
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

								collection = TableName.new(
									schema_name:,
									table_name:,
								)
							end
						elsif maybe :LP
							function_name = ref
							arguments = maybe_som { expression(next_precedence) }
							require :RP

							collection = FunctionReference.new(
								function_name:,
								arguments: FunctionArguments.new(
									expressions: arguments
								),
							)
						else
							table_name = ref

							collection = TableName.new(
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
					middle = expression(next_precedence)
					require :AND
					right = expression(next_precedence)
					return TernaryExpression.new(
						operator: (negated ? :NOT_BETWEEN : :BETWEEN),
						left: left,
						middle: middle,
						right: right
					)
				elsif maybe :LIKE
					expression_node = negated ? NotLikeExpression : LikeExpression
					right = expression(next_precedence)
					escape = maybe(:ESCAPE) ? expression : nil
					return expression_node.new(
						left:,
						right:,
						escape:,
					)
				elsif (match_tk = maybe_one_of :GLOB, :REGEXP, :MATCH)
					operator_tk = token_span_from(negated, match_tk)
					right = expression(next_precedence)

					left_attr = Node === left ? { left: left } : { left_tk: left }
					right_attr = Node === right ? { right: right } : { right_tk: right }

					return BinaryExpression.new(
						full_source: @lexer.sql,
						operator_tk: Token::Punctuation(operator_tk),
						**left_attr,
						**right_attr,
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
				elsif (is_tk = maybe :IS)
					negated_tk = maybe :NOT
					distinct_from_tk = maybe_all_of :DISTINCT, :FROM

					operator_tk = token_span_from(is_tk, negated_tk, distinct_from_tk)
					right = expression(next_precedence)

					left_attr = Node === left ? { left: left } : { left_tk: left }
					right_attr = Node === right ? { right: right } : { right_tk: right }

					left = BinaryExpression.new(
						full_source: @lexer.sql,
						operator_tk: Token::Punctuation(operator_tk),
						**left_attr,
						**right_attr,
					)
				elsif maybe :COLLATE
					left = CollationExpression.new(
						expression: left,
						collation_name: identifier.to_sym.upcase
					)
				else
					operator_tk = require operator
					right = expression(next_precedence)

					left_attr = Node === left ? { left: left } : { left_tk: left }
					right_attr = Node === right ? { right: right } : { right_tk: right }

					left = BinaryExpression.new(
						full_source: @lexer.sql,
						operator_tk: Token::Punctuation(operator_tk),
						**left_attr,
						**right_attr,
					)
				end
			end

			left
		end

		def column_def
			#
				# Used by:
				#   - alter_table_stmt
				#   - create_table_stmt
				#
				# Relevant `parse.y` grammar rules:
				#   columnlist ::= columnname carglist
				#   columnname ::= nm typetoken
				#   carglist ::= . | carglist ccons
				#
				# Syntax diagram:
				#   ◯─▶{ column-name }─┬─▶[ type-name ]─┬▶┬─▶───────────────────▶──┬─▶◯
				#                      └────────▶───────┘ └─[ column-constraint ]◀─┘
				#
				# Simplified grammar:
				#   name [type] [constraint [constraint]*]
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/lang_createtable.html#column_definitions
				#   - https://www.sqlite.org/syntax/column-def.html
				#
				# Each column definition consists of the name of the column,
				# optionally followed by the declared type of the column,
				# then one or more optional column constraints.
			#
			column_name = name
			column_type = maybe { type_name }
			constraints = maybe_some(sep: nil) do
				#
					# Relevant `parse.y` grammar rules:
					#   ccons ::= CONSTRAINT nm |
					#             DEFAULT term |
					#             DEFAULT LP expr RP |
					#             DEFAULT PLUS term |
					#             DEFAULT MINUS term |
					#             DEFAULT id |
					#             NULL onconf |
					#             NOT NULL onconf |
					#             PRIMARY KEY sortorder onconf autoinc |
					#             UNIQUE onconf |
					#             CHECK LP expr RP |
					#             REFERENCES nm eidlist_opt refargs |
					#             defer_subclause |
					#             COLLATE ids |
					#             GENERATED ALWAYS AS generated |
					#             AS generated
					#   term ::= NULL | FLOAT | BLOB | STRING | INTEGER | CTIME_KW | QNUMBER
					#   id ::= ID | INDEXED
					#   ids ::= ID | STRING
					#   nm ::= idj | STRING
					#   eidlist_opt ::= . | LP eidlist RP
					#   eidlist ::= eidlist COMMA nm collate sortorder |
					# 	            nm collate sortorder
					#   onconf ::= . | ON CONFLICT resolvetype
					#   sortorder ::= . | ASC | DESC
					#   refargs ::= . | refargs refarg
					#   refarg ::= MATCH nm |
					# 	           ON INSERT refact |
					# 	           ON DELETE refact |
					# 		         ON UPDATE refact
					#   generated ::= LP expr RP |
					#                 LP expr RP ID
					#   autoinc ::= . | AUTOINCR.
					#
					# Syntax diagram:
					#   ◯─▶┬▶{ CONSTRAINT }─▶{ name }─┬───────────────────────────────▶───────────────────────┐
					#      ├─────────────◀────────────┘                                                       │
					#      ├─▶{ PRIMARY }─▶{ KEY }──┬─────▶──────┬─▶[ conflict-clause ]┬──────────▶───────────┼─▶◯
					#      │                        ├─▶{ ASC }──▶┤                     └─▶{ AUTOINCREMENT }─▶─┤
					#      ├─────▶───┐              └─▶{ DESC }─▶┘                                            │
					#      ├─▶{ NOT }┴▶{ NULL }─▶[ conflict-clause ]────────────────────────────────────────▶─┤
					#      ├─▶{ UNIQUE }─▶[ conflict-clause ]───────────────────────────────────────────────▶─┤
					#      ├─▶{ CHECK }─▶{ ( }─▶[ expr ]─▶{ ) }─────────────────────────────────────────────▶─┤
					#      ├─▶{ DEFAULT }─▶┬▶{ ( }─▶[ expr ]─▶{ ) }──┬──────────────────────────────────────▶─┤
					#      │               ├─▶[ literal-value ]────▶─┤                                        │
					#      │               └─▶[ signed-number ]────▶─┘                                        │
					#      ├─▶{ COLLATE }─▶{ collation-name }───────────────────────────────────────────────▶─┤
					#      ├─▶[ foreign-key-clause ]────────────────────────────────────────────────────────▶─┤
					#      ├─▶{ GENERATED }─▶{ ALWAYS }┬▶{ AS }─▶{ ( }─▶[ expr ]─▶{ ) }┬────────────────────▶─┤
					#      └──────────────▶────────────┘                               ├─▶{ STORED }────────▶─┤
					#                                                                  └─▶{ VIRTUAL }───────▶─┘
					#
					# Simplified grammar:
					#   [CONSTRAINT name] (
					#     [PRIMARY KEY [ASC|DESC] [conflict_clause] [AUTOINCREMENT]]
					#     [NOT NULL [conflict_clause]]
					#     [NULL [conflict_clause]]
					#     [UNIQUE [conflict_clause]]
					#     [CHECK LP expression RP [conflict_clause]]
					#     [COLLATE collation-name]
					#     [foreign-key-clause]
					#     [GENERATED ALWAYS AS (expr) STORED | VIRTUAL]
					#   )
					#
					# Relevant SQLite documentation:
					#   - https://www.sqlite.org/lang_createtable.html#column_definitions
					#   - https://www.sqlite.org/syntax/column-constraint.html
					#
					# Included in the definition of "column constraints" for the purposes of the previous statement
					# are the COLLATE and DEFAULT clauses, even though these are not really constraints in the sense
					# that they do not restrict the data that the table may contain. The other constraints -
					# NOT NULL, CHECK, UNIQUE, PRIMARY KEY and FOREIGN KEY constraints - impose restrictions on the table data.
				#
				if (constraint_kw = maybe :CONSTRAINT)
					constraint_name = name
				end

				if    (primary_key_kw = maybe_all_of :PRIMARY, :KEY)
					direction_tk        = maybe_one_of :ASC, :DESC
					on_conflict         = maybe      { conflict_clause }
					autoincrement_kw    = maybe        :AUTOINCREMENT

					PrimaryKeyColumnConstraint.new(
						full_source:      @lexer.sql,
						constraint_kw:    Token::Keyword(constraint_kw),
						name_tk:          Token::Identifier(constraint_name),
						primary_key_kw:   Token::Keyword(primary_key_kw),
						direction_tk:     Token::Keyword(direction_tk),
						conflict_clause:  on_conflict,
						autoincrement_kw: Token::Keyword(autoincrement_kw),
					)
				elsif (not_null_kw    = maybe_all_of :NOT, :NULL)
					on_conflict         = maybe      { conflict_clause }

					NotNullColumnConstraint.new(
						full_source:     @lexer.sql,
						constraint_kw:   Token::Keyword(constraint_kw),
						name_tk:         Token::Identifier(constraint_name),
						not_null_kw:     Token::Keyword(not_null_kw),
						conflict_clause: on_conflict,
					)
				elsif (null_kw        = maybe        :NULL)
					on_conflict         = maybe      { conflict_clause }

					NullColumnConstraint.new(
						full_source:     @lexer.sql,
						constraint_kw:   Token::Keyword(constraint_kw),
						name_tk:         Token::Identifier(constraint_name),
						null_kw:         Token::Keyword(null_kw),
						conflict_clause: on_conflict,
					)
				elsif (unique_kw      = maybe        :UNIQUE)
					on_conflict         = maybe      { conflict_clause }

					UniqueColumnConstraint.new(
						full_source:     @lexer.sql,
						constraint_kw:   Token::Keyword(constraint_kw),
						name_tk:         Token::Identifier(constraint_name),
						unique_kw:       Token::Keyword(unique_kw),
						conflict_clause: on_conflict,
					)
				elsif (check_kw       = maybe        :CHECK)
					check_lp            = require      :LP
					check               =              expression
					check_rp            = require      :RP

					CheckColumnConstraint.new(
						full_source:   @lexer.sql,
						constraint_kw: Token::Keyword(constraint_kw),
						name_tk:       Token::Identifier(constraint_name),
						check_kw:      Token::Keyword(check_kw),
						check_lp:      Token::Punctuation(check_lp),
						expression:    check,
						check_rp:      Token::Punctuation(check_rp),
					)
				elsif (default_kw     = maybe        :DEFAULT)
					if (default_lp      = maybe        :LP)
						value         = expression
						default_rp    = require :RP

						DefaultColumnConstraint.new(
							full_source:   @lexer.sql,
							constraint_kw: Token::Keyword(constraint_kw),
							name_tk:       Token::Identifier(constraint_name),
							default_kw:    Token::Keyword(default_kw),
							default_lp:    Token::Punctuation(default_lp),
							default_rp:    Token::Punctuation(default_rp),
							value:         value,
						)
					elsif (number       = maybe      { signed_numeric })
						DefaultColumnConstraint.new(
							full_source:   @lexer.sql,
							constraint_kw: Token::Keyword(constraint_kw),
							name_tk:       Token::Identifier(constraint_name),
							default_kw:    Token::Keyword(default_kw),
							value_tk:      Token::Numeric(number),
						)
					elsif (value        = maybe      { literal_value })
						DefaultColumnConstraint.new(
							full_source:   @lexer.sql,
							constraint_kw: Token::Keyword(constraint_kw),
							name_tk:       Token::Identifier(constraint_name),
							default_kw:    Token::Keyword(default_kw),
							value_tk:      value,
						)
					elsif (id           = maybe      { identifier })
						DefaultColumnConstraint.new(
							full_source:   @lexer.sql,
							constraint_kw: Token::Keyword(constraint_kw),
							name_tk:       Token::Identifier(constraint_name),
							default_kw:    Token::Keyword(default_kw),
							value_tk:      id,
						)
					else
						expected! :LP, "literal-value", "signed-number"
					end
				elsif (collate_kw     = maybe        :COLLATE)
					collation = name

					CollateColumnConstraint.new(
						full_source:   @lexer.sql,
						constraint_kw: Token::Keyword(constraint_kw),
						name_tk:       Token::Identifier(constraint_name),
						collate_kw:    Token::Keyword(collate_kw),
						collation_tk:  Token::Identifier(collation),
					)
				elsif :REFERENCES == current_token
					clause = foreign_key_clause

					ForeignKeyColumnConstraint.new(
						full_source:        @lexer.sql,
						constraint_kw:      Token::Keyword(constraint_kw),
						name_tk:            Token::Identifier(constraint_name),
						foreign_key_clause: clause,
					)
				elsif (as_kw = maybe_all_of(:GENERATED, :ALWAYS, :AS) || maybe(:AS))
					as_lp      = require :LP
					default    = expression
					as_rp      = require :RP
					type_tk    = maybe_one_of :STORED, :VIRTUAL

					GeneratedAsColumnConstraint.new(
						full_source:        @lexer.sql,
						constraint_kw:      Token::Keyword(constraint_kw),
						name_tk:            Token::Identifier(constraint_name),
						as_kw:              Token::Keyword(as_kw),
						as_lp:              Token::Punctuation(as_lp),
						expression:         default,
						as_rp:              Token::Punctuation(as_rp),
						type_tk:            Token::Keyword(type_tk),
					)
				else
					if constraint_name
						NoOpColumnConstraint.new(
							full_source:   @lexer.sql,
							constraint_kw: Token::Keyword(constraint_kw),
							name_tk:       Token::Identifier(constraint_name),
						)
					else
						expected! :PRIMARY, :NOT, :NULL, :UNIQUE, :CHECK, :DEFAULT, :COLLATE, :REFERENCES, :GENERATED
					end
				end
			end

			ColumnDefinition.new(
				full_source: @lexer.sql,
				name:        Token::Identifier(column_name),
				type:        column_type,
				constraints: constraints,
			)
		end

		def filter_clause
			# Relevant `parse.y` grammar rules:
			#
			# Syntax diagram:
			#   ◯─▶{ FILTER }─▶{ ( }─▶{ WHERE }─▶[ expr ]─▶{ ) }─▶◯
			#
			# Simplified grammar:
			#
			# Relevant SQLite documentation:
			#   -
			#
			# [description]
			#
			require_all_of :FILTER, :LP, :WHERE
			condition = expression
			require :RP

			condition
		end

		def over_clause
			# Relevant `parse.y` grammar rules:
			#
			# Syntax diagram:
			#   ◯─▶{ OVER }┬─▶{ window-name }───────────────────────────────┬─▶◯
			#              └─▶{ ( }┬───────────▶────────────┐               │
			#                      └─▶{ base-window-name }─▶┤               │
			#                   ┌───────────────◀───────────┘               │
			#                   ├─▶{ PARTITION }─▶{ BY }┬[ expr ]┐          │
			#                   │                       └─{ , }◀─┤          │
			#                   ├────────────◀───────────────────┘          │
			#                   ├─▶{ ORDER }─▶{ BY }┬[ ordering-term ]┐     │
			#                   │                   └──────{ , }◀─────┤     │
			#                   ├─────────────◀───────────────────────┘     │
			#                   ├─▶[ frame-spec ]┬─▶──────────────────{ ) }─┘
			#                   └─────────▶──────┘
			#
			# Simplified grammar:
			#
			# Relevant SQLite documentation:
			#   -
			#
			# [description]
			#
			require :OVER
			if maybe :LP
				base_window_name = maybe { identifier(except: [:PARTITION, :ORDER, :RANGE, :ROWS, :GROUPS]) }
				partition_by = maybe_all_of(:PARTITION, :BY) ? require_some { expression } : nil
				order_by = maybe_all_of(:ORDER, :BY) ? require_some { ordering_term } : nil
				frame = frame_spec if current_token in :RANGE | :ROWS | :GROUPS
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

		def foreign_key_clause
			#
				# Relevant `parse.y` grammar rules:
				#   ccons ::= REFERENCES nm eidlist_opt refargs.
				#   eidlist_opt ::= . | LP eidlist RP
				#   eidlist ::= eidlist COMMA nm collate sortorder | nm collate sortorder
				#   refargs ::= . | refargs refarg
				#   refarg ::= MATCH nm |
				#              ON INSERT refact |
				#              ON DELETE refact |
				#              ON UPDATE refact
				#   refact ::= SET NULL |
				#              SET DEFAULT |
				#              CASCADE |
				#              RESTRICT |
				#              NO ACTION
				#   defer_subclause_opt ::= . | defer_subclause
				#   defer_subclause ::= NOT DEFERRABLE init_deferred_pred_opt |
				#                       DEFERRABLE init_deferred_pred_opt
				#   init_deferred_pred_opt ::= . | INITIALLY DEFERRED | INITIALLY IMMEDIATE
				#
				# Syntax diagram:
				#                                                ┌─────{ , }◀─────┐
				#   ◯─▶{ REFERENCES }─▶{ foreign-table }─┬─▶{ ( }┴▶{ column-name }┴▶{ ) }──┐
				#    ┌───────────────────────────────────┴──────────◀──┬───────────────────┘
				#    ├─▶{ ON }┬─▶{ DELETE }─┬┬─▶{ SET }─▶{ NULL }────▶─┤
				#    │        └─▶{ UPDATE }─┘├─▶{ SET }─▶{ DEFAULT }─▶─┤
				#    │                       ├─▶{ CASCADE }──────────▶─┤
				#    │                       ├─▶{ RESTRICT }─────────▶─┤
				#    │                       └─▶{ NO }─▶{ ACTION }───▶─┤
				#    ├─▶{ MATCH }─▶{ name }────────────────────────────┘
				#    ├────────────┬─▶{ DEFERRABLE }┬───────────────────────────────▶─┐
				#    ├─{ NOT }──▶─┘                ├─▶{ INITIALLY }─▶{ DEFERRED }──▶─┤
				#    │                             └─▶{ INITIALLY }─▶{ IMMEDIATE }─▶─┤
				#    └───────────────────────────────────────────────────────────────┴──────▶◯
				#
				# Simplified grammar:
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/syntax/foreign-key-clause.html
				#   - https://www.sqlite.org/foreignkeys.html
				#
				# [description]
			#
			references_kw = require :REFERENCES
			foreign_table = name(except: [:ON, :MATCH, :DEFERRABLE, :NOT])
			columns = nil
			if (columns_lp = maybe :LP)
				columns = require_some { indexed_column }
				columns_rp = require :RP
			end
			foreign_key_actions = maybe_some(sep: nil) do
				on_kw      = require        :ON
				trigger_kw = require_one_of :DELETE, :UPDATE
				action_kw  = require_one_of :CASCADE, :RESTRICT, [:SET, :NULL].freeze, [:SET, :DEFAULT].freeze, [:NO, :ACTION].freeze
				ForeignKeyAction.new(
					full_source: @lexer.sql,
					on_kw:       Token::Keyword(on_kw),
					trigger_kw:  Token::Keyword(trigger_kw),
					action_kw:   Token::Keyword(action_kw),
				)
			end
			match_clauses = maybe_some(sep: nil) do
				match_kw = require :MATCH
				type_tk  = name(except: [:ON, :MATCH, :DEFERRABLE, :NOT])
				MatchClause.new(
					full_source: @lexer.sql,
					match_kw:    Token::Keyword(match_kw),
					type_tk:     Token::Identifier(type_tk),
				)
			end

			deferrable_span = maybe_one_of(
				[:NOT, :DEFERRABLE, :INITIALLY, :IMMEDIATE].freeze,
				[:NOT, :DEFERRABLE, :INITIALLY, :DEFERRED].freeze,
				[:DEFERRABLE, :INITIALLY, :IMMEDIATE].freeze,
				[:DEFERRABLE, :INITIALLY, :DEFERRED].freeze,
				[:NOT, :DEFERRABLE].freeze,
				:DEFERRABLE,
			)

			ForeignKeyClause.new(
				full_source: @lexer.sql,
				references_kw: Token::Keyword(references_kw),
				table_tk: Token::Identifier(foreign_table),
				columns_lp: Token::Punctuation(columns_lp),
				columns: columns,
				columns_rp: Token::Punctuation(columns_rp),
				actions: foreign_key_actions,
				match_clauses: match_clauses,
				deferrable_span: Token::Keyword(deferrable_span),
			)
		end

		def conflict_clause
			#
				# Used by:
				#   - column_def
				#
				# Relevant `parse.y` grammar rules:
				#   onconf ::= . | ON CONFLICT resolvetype.
				#   orconf ::= . | OR resolvetype.
				#   resolvetype ::= raisetype |
				#                   IGNORE |
				#                   REPLACE
				#   raisetype ::= ROLLBACK |
				#                 ABORT |
				#                 FAIL
				#
				# Syntax diagram:
				#   ◯─▶┬────────────────────────────────────────┬─────▶◯
				#      └─▶{ ON }─▶{ CONFLICT }┬─▶{ ROLLBACK }─▶─┤
				#                             ├─▶{ ABORT }────▶─┤
				#                             ├─▶{ FAIL }─────▶─┤
				#                             ├─▶{ IGNORE }───▶─┤
				#                             └─▶{ REPLACE }──▶─┘
				#
				# Simplified grammar:
				#   [ON CONFLICT [ROLLBACK | ABORT | FAIL | IGNORE | REPLACE]]
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/lang_conflict.html
				#
				# The ON CONFLICT clause is a non-standard extension specific to SQLite
				# that can appear in many other SQL commands. There are five conflict resolution
				# algorithm choices: ROLLBACK, ABORT, FAIL, IGNORE, and REPLACE.
			#
			return unless (on_conflict_kw  = maybe_all_of :ON, :CONFLICT)

			if (resolution_kw = maybe_one_of :ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE)
				ConflictClause.new(
					full_source:    @lexer.sql,
					on_conflict_kw: Token::Keyword(on_conflict_kw),
					resolution_kw:  Token::Keyword(resolution_kw),
				)
			else
				expected! :ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE
			end
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
					conditions = require_some(sep: :WHEN) do
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
					conditions = require_some(sep: :WHEN) do
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
			elsif (v = maybe { literal_value })
				case v
				when LiteralNil then nil
				when LiteralFalse then false
				else v
				end
			elsif (id = maybe { name(except: [:RAISE]) })
				case current_token
				in :IN
					ColumnName.new(
						full_source: @lexer.sql,
						column_tk: Token::Identifier(id),
					)
				in :LP
					function_name = id.to_sym.upcase
					require :LP
					arguments = function_arguments
					require :RP
					filter = maybe { filter_clause }
					over = maybe { over_clause }

					FunctionReference.new(
						function_name:,
						arguments:,
						filter_clause: filter,
						over_clause: over,
					)
				in :DOT
					schema_or_table_name = id
					dot = require :DOT
					table_or_column_name = name
					if (dot2 = maybe :DOT)
						column_name = name
						ColumnName.new(
							full_source: @lexer.sql,
							schema_tk: Token::Identifier(schema_or_table_name),
							dot1: Token::Punctuation(dot),
							table_tk: Token::Identifier(table_or_column_name),
							dot2: Token::Punctuation(dot2),
							column_tk: Token::Identifier(column_name),
						)
					else
						ColumnName.new(
							full_source: @lexer.sql,
							table_tk: Token::Identifier(schema_or_table_name),
							dot2: Token::Punctuation(dot),
							column_tk: Token::Identifier(table_or_column_name),
						)
					end
				else
					ColumnName.new(
						full_source: @lexer.sql,
						column_tk: Token::Identifier(id),
					)
				end
			elsif :RAISE == current_token
				raise_function
			elsif (var = maybe :VARIABLE)
				var
			else
				expected!("<basic expression>")
			end
		end

		def raise_function
			# Relevant `parse.y` grammar rules:
			#
			# Syntax diagram:
			#   ◯─▶{ RAISE }─▶{ ( }┬─▶{ IGNORE }────────────────────▶─────────┬▶{ ) }──▶◯
			#                      ├─▶{ ROLLBACK }─┬▶{ , }─▶{ error-message }─┘
			#                      ├─▶{ ABORT }──▶─┤
			#                      └─▶{ FAIL }───▶─┘
			#
			# Simplified grammar:
			#
			# Relevant SQLite documentation:
			#   -
			#
			# [description]
			#
			require_all_of :RAISE, :LP
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
			# Relevant `parse.y` grammar rules:
			#
			# Syntax diagram:
			#       ┌─▶{ DISTINCT }─▶┐ ┌──{ , }◀─┐
			#   ◯─▶─┼────────────────┴▶┴▶[ expr ]┼───────────┬─┬─▶◯
			#       │ ┌──────────────────────────┘           │ │
			#       │ └▶{ ORDER }─▶{ BY }┬▶[ ordering-term ]─┤ │
			#       │                    └───────{ , }◀──────┘ │
			#       └─────────────────┬▶{ * }┬▶────────────────┘
			#                         └───▶──┘
			#
			# Simplified grammar:
			#
			# Relevant SQLite documentation:
			#   -
			#
			# [description]
			#
			if maybe :DISTINCT
				distinct = true
				expressions = require_some { expression }
				order_by = maybe_all_of(:ORDER, :BY) ? require_some { ordering_term } : nil

				FunctionArguments.new(
					distinct:,
					expressions:,
					order_by:,
				)
			elsif maybe :STAR
				StarFunctionArgument.new
			elsif (e = maybe { expression })
				expressions = require_some(given: e) { expression }
				order_by = maybe_all_of(:ORDER, :BY) ? require_some { ordering_term } : nil

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

		def frame_spec
			# Relevant `parse.y` grammar rules:
			#
			# Syntax diagram:
			#   ◯┬─▶{ RANGE }──┬┬▶{ BETWEEN }┬─▶{ UNBOUNDED }─▶{ PRECEDING }┬▶{ AND }┬─▶[ expr ]─▶{ PRECEDING }────▶─┐
			#    ├─▶{ ROWS }───┤│            ├─▶[ expr ]─▶{ PRECEDING }─────┤        ├─▶{ CURRENT }─▶{ ROW }───────▶─┤
			#    └─▶{ GROUPS }─┘│            ├─▶{ CURRENT }─▶{ ROW }────────┤        ├─▶[ expr ]─▶{ FOLLOWING }────▶─┤
			#                   │            └─▶[ expr ]─▶{ FOLLOWING }─────┘        └─▶{ UNBOUNDED }─▶{ FOLLOWING }─┤
			#                   ├─▶{ UNBOUNDED }─▶{ PRECEDING }────────────────────────────────────────────────────▶─┤
			#                   ├─▶[ expr ]─▶{ PRECEDING }─────────────────────────────────────────────────────────▶─┤
			#                   └─▶{ CURRENT }─▶{ ROW }────────────────────────────────────────────────────────────▶─┤
			#                                           ┌────────────────────────────────────────────────────────────┘
			#                                           ├─▶{ EXCLUDE }─▶{ NO }─▶{ OTHERS }───▶─┐
			#                                           ├─▶{ EXCLUDE }─▶{ CURRENT }─▶{ ROW }─▶─┤
			#                                           ├─▶{ EXCLUDE }─▶{ GROUP }────────────▶─┤
			#                                           ├─▶{ EXCLUDE }─▶{ TIES }─────────────▶─┤
			#                                           └──────────────────────────────────────┴─────────▶◯
			#
			# Simplified grammar:
			#
			# Relevant SQLite documentation:
			#   -
			#
			# [description]
			#
			if current_token in :RANGE | :ROWS | :GROUPS
				type = current_token
				require current_token
				if maybe :BETWEEN
					if maybe_all_of :UNBOUNDED, :PRECEDING
						precedence = 1
						starting_boundary = FrameBoundary.new(
							type: :PRECEDING,
							value: :UNBOUNDED
						)
					elsif maybe_all_of :CURRENT, :ROW
						precedence = 3
						starting_boundary = FrameBoundary.new(
							type: :CURRENT_ROW
						)
					elsif (e = maybe { expression })
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
					if maybe_all_of :CURRENT, :ROW
						expected!("UNBOUNDED FOLLOWING", "expr") if 3 < precedence
						ending_boundary = FrameBoundary.new(
							type: :CURRENT_ROW,
						)
					elsif maybe_all_of :UNBOUNDED, :FOLLOWING
						ending_boundary = FrameBoundary.new(
							type: :FOLLOWING,
							value: :UNBOUNDED
						)
					elsif (e = maybe { expression })
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
				elsif maybe_all_of :UNBOUNDED, :PRECEDING
					starting_boundary = FrameBoundary.new(
						type: :PRECEDING,
						value: :UNBOUNDED
					)
					ending_boundary = nil
				elsif maybe_all_of :CURRENT, :ROW
					starting_boundary = FrameBoundary.new(
						type: :CURRENT_ROW
					)
					ending_boundary = nil
				elsif (e = maybe { expression })
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
					elsif maybe_all_of :NO, :OTHERS
						exclude = :NO_OTHERS
					elsif maybe_all_of :CURRENT, :ROW
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

		# ---------- Objects ----------

		def type_name
			#
				# Used by:
				#   - column_def
				#   - expression
				#
				# Relevant `parse.y` grammar rules:
				#   typetoken ::= . | typename. | typename LP signed RP | typename LP signed COMMA signed RP
				#   typename ::= ids | typename ids
				#   signed ::= plus_num | minus_num
				#   plus_num ::= PLUS number | number
				#   minus_num ::= MINUS number
				#   number ::= INTEGER | FLOAT
				#
				# Syntax diagram:
				#   ◯─┬▶{ name }─┬┬──────────────────────────────▶─────────────────────────────┬─▶◯
				#     └────◀─────┘├─▶{ ( }─▶[ signed-number ]─▶{ ) }─────────────────────────▶─┤
				#                 └─▶{ ( }─▶[ signed-number ]─▶{ , }─▶[ signed-number ]─▶{ ) }─┘
				#
				# Simplified grammar:
				#   name [name]* [LP signed_number [, signed_number] RP]
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/syntax/type-name.html
				#   - https://www.sqlite.org/datatype3.html
				#   - https://www.sqlite.org/flextypegood.html
				#
				# A typetoken is really zero or more tokens that form a type name such
				# as can be found after the column name in a CREATE TABLE statement.
				# Multiple tokens are concatenated to form the value of the typetoken.
			#
			text = scan do
				require_some(sep: nil) do
					identifier_or_string(
						# Don't consume tokens that mark the start of a `column_constraint`
						except: Set[:CONSTRAINT, :PRIMARY, :NOT, :NULL, :UNIQUE, :CHECK, :DEFAULT, :COLLATE, :REFERENCES, :GENERATED, :AS]
					)
				end
				if maybe :LP
					signed_number
					signed_number if maybe :COMMA
					require :RP
				end
			end

			ColumnType.new(
				full_source: @lexer.sql,
				text_span: Token::Keyword(text),
			)
		end

		def table_name
			#
				# Used by:
				#   - drop table
				#   - delete
				#   - update
				#   - insert
				#   - alter table
				#
				# Relevant `parse.y` grammar rules:
				#   fullname ::= nm | nm DOT nm
				#
				# Syntax diagram:
				#   ◯─▶┬▶{ schema-name }─▶{ . }┬▶{ object-name }─▶◯
				#      └───────────▶───────────┘
				#
				# Simplified grammar:
				#   name [DOT name]
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/lang_createtable.html
				#   - https://www.sqlite.org/lang_createvtab.html
				#
				# A table or virtual table name, where the schema name is optional.
			#

			if peek == :DOT
				schema_tk = name
				dot_tk    = require :DOT
				table_tk  = name

				TableName.new(
					full_source: @lexer.sql,
					schema_tk:   Token::Identifier(schema_tk),
					dot_tk:      Token::Punctuation(dot_tk),
					table_tk:    Token::Identifier(table_tk),
				)
			else
				table_tk = name

				TableName.new(
					full_source: @lexer.sql,
					table_tk:    Token::Identifier(table_tk),
				)
			end
		end

		def literal_value
			#
				# Relevant `parse.y` grammar rules:
				#   term ::= NULL | FLOAT | BLOB | STRING | INTEGER | CTIME_KW | QNUMBER
				#
				# Syntax diagram:
				#   ◯─┬─▶{ numeric-literal }────▶─┬─▶◯
				#     ├─▶{ string-literal }─────▶─┤
				#     ├─▶{ blob-literal }───────▶─┤
				#     ├─▶{ NULL }───────────────▶─┤
				#     ├─▶{ TRUE }───────────────▶─┤
				#     ├─▶{ FALSE }──────────────▶─┤
				#     ├─▶{ CURRENT_TIME }───────▶─┤
				#     ├─▶{ CURRENT_DATE }───────▶─┤
				#     └─▶{ CURRENT_TIMESTAMP }──▶─┘
				#
				# Simplified grammar:
				#   NULL | CURRENT_TIME | CURRENT_DATE | CURRENT_TIMESTAMP | INTEGER | FLOAT | STRING | BLOB | TRUE | FALSE | QNUMBER
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/syntax/literal-value.html
				#
				# A value
			#

			case current_token
			when :NULL
				tk = require :NULL
				Token::Null(tk)
			when :CURRENT_TIME
				tk = require :CURRENT_TIME
				Token::Current(tk)
			when :CURRENT_DATE
				tk = require :CURRENT_DATE
				Token::Current(tk)
			when :CURRENT_TIMESTAMP
				tk = require :CURRENT_TIMESTAMP
				Token::Current(tk)
			when :TRUE
				tk = require :TRUE
				Token::True(tk)
			when :FALSE
				tk = require :FALSE
				Token::False(tk)
			when :QNUMBER
				tk = require :QNUMBER
				Token::Numeric(tk)
			when :INTEGER
				tk = require :INTEGER
				Token::Numeric(tk)
			when :FLOAT
				tk = require :FLOAT
				Token::Numeric(tk)
			when :STRING
				tk = require :STRING
				Token::String(tk)
			when :BLOB
				tk = require :BLOB
				Token::Blob(tk)
			else
				expected!(:INTEGER, :FLOAT, :QNUMBER, :STRING, :BLOB, :NULL, :TRUE, :FALSE, :CURRENT_TIME, :CURRENT_DATE, :CURRENT_TIMESTAMP)
			end
		end

		def indexed_column
			# Used by:
			#   - ccons, tcons, creat-view, cte
			#
			# Relevant `parse.y` grammar rules:
			#   eidlist ::= eidlist COMMA nm collate sortorder | nm collate sortorder
			#   collate ::= . | COLLATE ids.
			#   sortorder ::= . | ASC | DESC
			#   nm ::= idj | STRING
			#
			# Syntax diagram:
			#   ◯──▶{ column-name }─┬─▶───────────────────────────────┬┬────────▶───┬──▶◯
			#                       └─▶{ COLLATE }─▶{ collation-name }┘├─▶{ ASC }─▶─┤
			#                                                          └─▶{ DESC }──┘
			#
			# Simplified grammar:
			#   name [COLLATE identifier] [ASC | DESC]
			#
			# Relevant SQLite documentation:
			#   - https://www.sqlite.org/syntax/indexed-column.html
			#
			# The eidlist non-terminal (Expression Id List) generates an ExprList
			# from a list of identifiers.  The identifier names are in ExprList.a[].zName.
			# This list is stored in an ExprList rather than an IdList so that it
			# can be easily sent to sqlite3ColumnsExprList().
			#
			# IMPORTANT COMPATIBILITY NOTE:  Some prior versions of SQLite accepted
			# COLLATE clauses and ASC or DESC keywords on ID lists in inappropriate
			# places - places that might have been stored in the sqlite_schema table.
			# Those extra features were ignored.  But because they might be in some
			# (busted) old databases, we need to continue parsing them when loading
			# historical schemas.
			#
			column_name  = name(except: [:COLLATE, :ASC, :DESC].freeze)
			if (collate_kw = maybe :COLLATE)
				collation_tk = identifier_or_string(except: [:ASC, :DESC].freeze)
			end
			direction_tk = maybe_one_of :ASC, :DESC

			IndexedColumn.new(
				full_source: @lexer.sql,
				name_tk:      Token::Identifier(column_name),
				collate_kw:   Token::Keyword(collate_kw),
				collation_tk: Token::Keyword(collation_tk),
				direction_tk: Token::Keyword(direction_tk)
			)
		end

		def indexed_expression
			# Used by:
			#   - tcons, upsert, expr (ORDER BY), create-index, window
			#
			# Relevant `parse.y` grammar rules:
			#   sortlist  ::= sortlist COMMA expr sortorder nulls | expr sortorder nulls
			#   sortorder ::= . | ASC | DESC
			#   nulls     ::= . | NULLS FIRST | NULLS LAST
			#
			# Syntax diagram:
			#   ◯─▶[ expr ]─┬────────▶───┬─┬────────────▶────────────┬───▶◯
			#               ├─▶{ ASC }─▶─┤ ├─▶{ NULLS }─▶{ FIRST }─▶─┤
			#               └─▶{ DESC }──┘ └─▶{ NULLS }─▶{ LAST }────┘
			#
			# Simplified grammar:
			#   expression [ASC | DESC] [NULLS FIRST | NULLS LAST]
			#
			# Relevant SQLite documentation:
			#   - https://www.sqlite.org/syntax/indexed-column.html
			#   - https://www.sqlite.org/expridx.html
			#
			# the sortlist non-terminal stores a list of expression where each
			# expression is optionally followed by ASC or DESC to indicate the
			# sort order.
			#
			expr         = expression
			direction_tk = maybe_one_of :ASC, :DESC
			nulls_tk     = maybe_one_of [:NULLS, :FIRST].freeze, [:NULLS, :LAST].freeze

			IndexedExpression.new(
				expression: expr,
				direction_tk: Token::Keyword(direction_tk),
				nulls_tk: Token::Keyword(nulls_tk)
			)
		end

		def ordering_term
			# Relevant `parse.y` grammar rules:
			#
			# Syntax diagram:
			#   ◯─▶[ expr ]┬───────────────▶────────────────┬▶┬──────▶─────┬▶┬──────────▶─────────────┬─▶◯
			#              └▶{ COLLATE }─▶{ collation-name }┘ ├▶{ ASC }──▶─┤ ├▶{ NULLS }─▶{ FIRST }─▶─┤
			#                                                 └▶{ DESC }─▶─┘ └▶{ NULLS }─▶{ LAST }──▶─┘
			#
			# Simplified grammar:
			#
			# Relevant SQLite documentation:
			#   -
			#
			# [description]
			#
			e = expression
			collation = maybe(:COLLATE) ? identifier : nil
			if current_token in :ASC | :DESC
				direction = current_token
				require current_token
			end
			if maybe(:NULLS)
				nulls = current_token
				require current_token
			end

			OrderingTerm.new(
				expression: e,
				collation: collation,
				direction: direction,
				nulls: nulls
			)
		end

		def signed_number
			#
				# Used by:
				#   - pragma_value
				#   - type_name
				#
				# Relevant `parse.y` grammar rules:
				#   signed ::= plus_num | minus_num
				#   plus_num ::= PLUS number | number
				#   minus_num ::= MINUS number
				#   number ::= INTEGER | FLOAT
				#
				# Syntax diagram:
				#   ◯─┬───▶────┬─▶{ numeric-literal }─▶◯
				#     ├─▶{ + }─┤
				#     └─▶{ - }─┘
				#
				# Simplified grammar:
				#   [PLUS | MINUS] INTEGER | FLOAT
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/syntax/signed-number.html
				#
				# A signed number is a numeric literal with an optional sign.
			#
			sign_tk  = maybe_one_of   :PLUS, :MINUS
			value_tk = require_one_of :INTEGER, :FLOAT

			return value_tk unless sign_tk

			sign_tk, beg, _fin = sign_tk
			value_tk, _beg, fin = value_tk

			[[sign_tk, value_tk], beg, fin]
		end

		def signed_numeric
			#
				# Used by:
				#   - column_constraint
				#
				# Relevant `parse.y` grammar rules:
				#   ccons ::= DEFAULT PLUS term | DEFAULT MINUS term
				#   expr ::= expr PLUS|MINUS expr | term
				#   term ::= NULL | FLOAT | BLOB | STRING | INTEGER | CTIME_KW | QNUMBER
				#
				# Syntax diagram:
				#   ◯─┬───▶────┬─▶{ numeric-literal }─▶◯
				#     ├─▶{ + }─┤
				#     └─▶{ - }─┘
				#
				# Simplified grammar:
				#   [PLUS | MINUS] INTEGER | FLOAT | QNUMBER
				#
				# Relevant SQLite documentation:
				#   - https://www.sqlite.org/syntax/signed-number.html
				#
				# A signed number is a numeric literal with an optional sign.
			#
			sign_tk  = maybe_one_of   :PLUS, :MINUS
			value_tk = require_one_of :INTEGER, :FLOAT, :QNUMBER

			return value_tk unless sign_tk

			sign_tk, beg, _fin = sign_tk
			value_tk, _beg, fin = value_tk

			[[sign_tk, value_tk], beg, fin]
		end

		# ---------- Token Classes ----------


		def name(except: [])
			# Relevant `parse.y` grammar rules:
			#   // The name of a column or table can be any of the following:
			#   nm ::= idj | STRING
			#
			if current_token in :STRING
				require current_token
			elsif (idj = maybe { identifier_or_join_keyword(except: except) })
				idj
			else
				expected!(:STRING, 'idj')
			end
		end

		def identifier(except: [])
			# Relevant `parse.y` grammar rules:
			#   // An IDENTIFIER can be a generic identifier, or one of several
			#   // keywords.  Any non-standard keyword can also be an identifier.
			#   %token_class id  ID | INDEXED
			#
			if current_token in :ID | :INDEXED
				require current_token
			elsif !except.include?(current_token) && TOKEN_FALLBACKS.include?(current_token)
				require current_token
			else
				expected!(:ID, :INDEXED, 'fallback')
			end
		end

		def identifier_or_string(except: [])
			# Relevant `parse.y` grammar rules:
			#   // And "ids" is an identifer-or-string.
			#   %token_class ids  ID | STRING
			#
			if current_token in :ID | :STRING
				require current_token
			elsif !except.include?(current_token) && TOKEN_FALLBACKS.include?(current_token)
				require current_token
			else
				expected!(:ID, :STRING, 'fallback')
			end
		end

		def identifier_or_join_keyword(except: [])
			# Relevant `parse.y` grammar rules:
			#   // An identifier or a join-keyword
			#   %token_class idj  ID | INDEXED | JOIN_KW
			#
			if current_token in :ID | :INDEXED | :CROSS | :FULL | :INNER | :LEFT | :NATURAL | :OUTER | :RIGHT
				require current_token
			elsif !except.include?(current_token) && TOKEN_FALLBACKS.include?(current_token)
				require current_token
			else
				expected!(:ID, :INDEXED, :JOIN_KW, 'fallback')
			end
		end

		private

		# ---------- Parsing Helpers ----------

		def require(token)
			if token == current_token
				advance
			else
				expected!(token)
			end
		end

		def maybe(token = nil) # &block
			if block_given?
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
			elsif token == current_token
				advance
			end
		end

		def scan(&block)
			ensure_buffer
			beg = @lexer.anchor
			ret = block.call
			ensure_buffer
			fin = (@lexer.cursor == @lexer.anchor+1) ? @lexer.anchor : @lexer.anchor-1
			[[], beg, fin]
		end

		def require_all_of(*tokens)
			i, len = 0, tokens.length
			start_pos, end_pos = nil
			while i < len
				if tokens[i] == current_token
					_tok, beg, fin = advance
					start_pos = beg if i == 0 # first iteration
					end_pos = fin if i == (len - 1) # last iteration

					i += 1
				else
					# TODO: only show the tokens from `i` onwards
					expected!(tokens)
				end
			end

			[tokens, start_pos, end_pos].freeze
		end

		def maybe_all_of(*tokens)
			advancing = true
			i, len = 0, tokens.length
			buf = ensure_buffer(len)
			while i < len
				tok, * = buf[i]
				if tokens[i] != tok
					advancing = false
					break
				end
				i += 1
			end

			require_all_of(*tokens) if advancing
		end

		def maybe_one_of(*tokens)
			i, len = 0, tokens.length
			while i < len
				check = tokens[i]
				if Symbol === check && (result = maybe check)
					return result
				elsif Array === check && (result = maybe_all_of *check)
					return result
				else
					i += 1
				end
			end

			nil
		end

		def require_one_of(*tokens)
			i, len = 0, tokens.length
			while i < len
				check = tokens[i]
				if Symbol === check && (result = maybe check)
					return result
				elsif Array === check && (result = maybe_all_of *check)
					return result
				else
					i += 1
				end
			end

			expected!(*tokens)
		end

		def require_some(sep: :COMMA, given: nil, &block)
			a = []
			a << (given || yield)

			if Array === sep
				i, len = 0, sep.length
				while i < len
					collect(into: a, sep: sep[i], &block)
					i += 1
				end
			else
				collect(into: a, sep: sep, &block)
			end

			return a unless a.all?(Array)

			beg = a[0][1]
			fin = a[-1][2]
			tks = a.map(&:first)
			[tks, beg, fin]
		end

		def maybe_some(sep: :COMMA, &block)
			a = []
			first_val = maybe { yield }

			if first_val
				a << first_val

				if Array === sep
					i, len = 0, sep.length
					while i < len
						collect(into: a, sep: sep[i], &block)
						i += 1
					end
				else
					collect(into: a, sep: sep, &block)
				end

				return a unless a.all?(Array)

				beg = a[0][1]
				fin = a[-1][2]
				tks = a.map(&:first)
				[tks, beg, fin]
			end
		end

		def token_span_from(*spans)
			spans.compact!
			i, len = 0, spans.length
			start_pos, end_pos = nil
			tokens = []
			while i < len
				tok, beg, fin = spans[i]
				Array === tok ? (tokens.concat(tok)) : (tokens << tok)
				start_pos = beg if i == 0 # first iteration
				end_pos = fin if i == (len - 1) # last iteration

				i += 1
			end

			[tokens, start_pos, end_pos]
		end

		def collect(into:, sep: :COMMA, &block)
			while true
				sep_tk = maybe(sep)
				val = maybe { yield }

				val ? into << val : break
			end
		end

		# Access the current token type in the lexer stream.
		# Reads but doesn't consume the token at the head of the buffer.
		def current_token
			buf = ensure_buffer
			buf[0][0]
		end

		# Access the string value for the current token.
		# Reads but doesn't consume the start_pos and end_pos values at the head of the buffer.
		def current_value
			buf = ensure_buffer
			sql = @lexer.sql
			_tk, beg, fin = buf[0]

			sql.byteslice(beg, (fin - beg))
		end

		# Peek at the next `n` tokens in the lexer stream.
		# Does not advance the lexer cursor and does not consider the current token.
		def peek(n = 1)
			buf = ensure_buffer(n + 1)
			return buf[1][0] if n == 1 # symbol element of the 2nd token

			[].tap do |a|
				i, len = 1, buf.length
				while i <= n
					tok, * = buf[i]
					a << tok
					i += 1
				end
			end
		end

		# Advance the implicit cursor pointing to the first token in the buffer by `n` tokens.
		# Returns the new token at the head of the buffer.
		def advance
			ensure_buffer
			@peek_buffer.shift
		end

		# Ensure that the `@peek_buffer` has at least `size` tokens.
		# Note: the buffer is a nested array of `[token, start_pos, end_pos]` triples
		def ensure_buffer(size = 1)
			lexer = @lexer
			@peek_buffer.tap do |buf|
				while buf.size < size
					buf << [lexer.next_token, lexer.anchor, lexer.cursor].freeze
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