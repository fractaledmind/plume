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
			ESCAPE:   52,
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

		SIMPLE_FUNCTION_NAMES = Set[
			:ABS,
			:ACOS,
			:ACOSH,
			:ASIN,
			:ASINH,
			:ATAN,
			:ATAN2,
			:ATANH,
			:CEIL,
			:CEILING,
			:CHANGES,
			:CHAR,
			:COALESCE,
			:CONCAT,
			:CONCAT_WS,
			:COS,
			:COSH,
			:DATE,
			:DATETIME,
			:DEGREES,
			:EXP,
			:FLOOR,
			:FORMAT,
			:GLOB,
			:HEX,
			:IFNULL,
			:IIF,
			:INSTR,
			:JULIANDAY,
			:JSON,
			:JSONB,
			:JSON_ARRAY,
			:JSONB_ARRAY,
			:JSON_ARRAY_LENGTH,
			:JSON_ERROR_POSITION,
			:JSON_EXTRACT,
			:JSONB_EXTRACT,
			:JSON_INSERT,
			:JSONB_INSERT,
			:JSON_OBJECT,
			:JSONB_OBJECT,
			:JSON_PATCH,
			:JSONB_PATCH,
			:JSON_PRETTY,
			:JSON_REMOVE,
			:JSONB_REMOVE,
			:JSON_REPLACE,
			:JSONB_REPLACE,
			:JSON_SET,
			:JSONB_SET,
			:JSON_TYPE,
			:JSON_VALID,
			:JSON_QUOTE,
			:LAST_INSERT_ROWID,
			:LENGTH,
			:LIKE,
			:LIKELIHOOD,
			:LIKELY,
			:LN,
			:LOAD_EXTENSION,
			:LOG,
			:LOG10,
			:LOG2,
			:LOWER,
			:LTRIM,
			:MAX,
			:MIN,
			:MOD,
			:NULLIF,
			:OCTET_LENGTH,
			:PI,
			:POW,
			:POWER,
			:PRINTF,
			:QUOTE,
			:RADIANS,
			:RANDOM,
			:RANDOMBLOB,
			:REPLACE,
			:ROUND,
			:RTRIM,
			:SIGN,
			:SIN,
			:SINH,
			:SOUNDEX,
			:SQLITE_COMPILEOPTION_GET,
			:SQLITE_COMPILEOPTION_USED,
			:SQLITE_OFFSET,
			:SQLITE_SOURCE_ID,
			:SQLITE_VERSION,
			:SQRT,
			:STRFTIME,
			:SUBSTR,
			:SUBSTRING,
			:TAN,
			:TANH,
			:TIME,
			:TIMEDIFF,
			:TOTAL_CHANGES,
			:TRIM,
			:TRUNC,
			:TYPEOF,
			:UNHEX,
			:UNICODE,
			:UNIXEPOCH,
			:UNLIKELY,
			:UPPER,
			:ZEROBLOB,
		].freeze

		AGGREGATE_FUNCTION_NAMES = Set[
			:AVG,
			:COUNT,
			:GROUP_CONCAT,
			:MAX,
			:MIN,
			:STRING_AGG,
			:SUM,
			:TOTAL,
		].freeze

		WINDOW_FUNCTION_NAMES = Set[
			:ROW_NUMBER,
			:RANK,
			:DENSE_RANK,
			:PERCENT_RANK,
			:CUME_DIST,
			:NTILE,
			:LAG,
			:LEAD,
			:FIRST_VALUE,
			:LAST_VALUE,
			:NTH_VALUE,
			:AVG,
			:COUNT,
			:GROUP_CONCAT,
			:MAX,
			:MIN,
			:STRING_AGG,
			:SUM,
			:TOTAL,
		].freeze

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
						elsif (s = optional { select_stmt })
							require :RP

							return expression_node.new(
								member: left,
								collection: s
							)
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
					op = negated ? "NOT#{mop}".to_sym : mop
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
					op = negated ? "#{op}NOT".to_sym : op
					maybe_all :DISTINCT, :FROM
					right = expression(op_precedence + 1)
					left = BinaryExpression.new(
						operator: TOKEN_TO_OPERATOR[op],
						left:,
						right:,
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
				e = expression(0)
				require :RP
				e
			elsif (v = optional { literal_value })
				case v
				when NIL then nil
				when FALSE then false
				else v
				end
			elsif :ID == current_token
				case peek(2)
				in [:IN, :LP]
					ColumnReference.new(
						column_name: identifier,
					)
				in [:LP, _]
					#  ├─▶{ function-name }─▶{ ( }─▶[ function-arguments ]─▶{ ) }┬───────────────────┬┬─────────────────────▶─┤
					#                                                            └▶[ filter-clause ]─┘└▶[ over-clause ]─────▶─┤
					function_name = current_value.to_sym.upcase

					if SIMPLE_FUNCTION_NAMES.include?(function_name)
						simple_function_invocation
					elsif AGGREGATE_FUNCTION_NAMES.include?(function_name)
						aggregate_function_invocation
					elsif WINDOW_FUNCTION_NAMES.include?(function_name)
						window_function_invocation
					else
						function_name = identifier
						require :LP
						# args = one_or_more { expression }
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
						require :RP

						filter = optional { filter_clause }
						if maybe :OVER
							window = (:LP == current_token) ? window_defn : identifier
						end
						FunctionReference.new(
							function_name: func,
							arguments: args,
						)
					end
				in [_, :DOT]
					schema_or_table_name = identifier
					accept :DOT
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
			else
				expected!(".............")
			end
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
			when :ABS	then arg = expr
			when :ACOS	then arg = expr
			when :ACOSH	then arg = expr
			when :ASIN	then arg = expr
			when :ASINH	then arg = expr
			when :ATAN	then arg = expr
			when :ATAN2	then args = one_or_more { expr }
			when :ATANH	then arg = expr
			when :CEIL	then arg = expr
			when :CEILING	then arg = expr
			when :CHANGES
				maybe(:STAR)
				require :RP
				:CHANGES
			when :CHAR	then args = one_or_more { expr }
			when :COALESCE	then args = one_or_more { expr }
			when :CONCAT	then args = one_or_more { expr }
			when :CONCAT_WS	then args = one_or_more { expr }
			when :COS	then arg = expr
			when :COSH	then arg = expr
			when :DATE	then args = one_or_more { expr }
			when :DATETIME	then args = one_or_more { expr }
			when :DEGREES	then arg = expr
			when :EXP	then arg = expr
			when :FLOOR	then arg = expr
			when :FORMAT	then args = one_or_more { expr }
			when :GLOB	then args = one_or_more { expr }
			when :HEX	then arg = expr
			when :IFNULL	then args = one_or_more { expr }
			when :IIF	then args = one_or_more { expr }
			when :INSTR	then args = one_or_more { expr }
			when :JULIANDAY	then args = one_or_more { expr }
			when :JSON	then arg = expr
			when :JSONB	then arg = expr
			when :JSON_ARRAY	then args = one_or_more { expr }
			when :JSONB_ARRAY	then args = one_or_more { expr }
			when :JSON_ARRAY_LENGTH	then args = one_or_more { expr }
			when :JSON_ERROR_POSITION	then arg = expr
			when :JSON_EXTRACT	then args = one_or_more { expr }
			when :JSONB_EXTRACT	then args = one_or_more { expr }
			when :JSON_INSERT	then args = one_or_more { expr }
			when :JSONB_INSERT	then args = one_or_more { expr }
			when :JSON_OBJECT	then args = one_or_more { expr }
			when :JSONB_OBJECT	then args = one_or_more { expr }
			when :JSON_PATCH	then args = one_or_more { expr }
			when :JSONB_PATCH	then args = one_or_more { expr }
			when :JSON_PRETTY	then arg = expr
			when :JSON_REMOVE	then args = one_or_more { expr }
			when :JSONB_REMOVE	then args = one_or_more { expr }
			when :JSON_REPLACE	then args = one_or_more { expr }
			when :JSONB_REPLACE	then args = one_or_more { expr }
			when :JSON_SET	then args = one_or_more { expr }
			when :JSONB_SET	then args = one_or_more { expr }
			when :JSON_TYPE	then args = one_or_more { expr }
			when :JSON_VALID	then args = one_or_more { expr }
			when :JSON_QUOTE	then arg = expr
			when :LAST_INSERT_ROWID
				maybe(:STAR)
				require :RP
				:LAST_INSERT_ROWID
			when :LENGTH	then arg = expr
			when :LIKE	then args = one_or_more { expr }
			when :LIKELIHOOD	then args = one_or_more { expr }
			when :LIKELY	then arg = expr
			when :LN	then arg = expr
			when :LOAD_EXTENSION	then args = one_or_more { expr }
			when :LOG	then args = one_or_more { expr }
			when :LOG10	then arg = expr
			when :LOG2	then arg = expr
			when :LOWER	then arg = expr
			when :LTRIM	then args = one_or_more { expr }
			when :MAX	then args = one_or_more { expr }
			when :MIN	then args = one_or_more { expr }
			when :MOD	then args = one_or_more { expr }
			when :NULLIF	then args = one_or_more { expr }
			when :OCTET_LENGTH	then arg = expr
			when :PI
				maybe(:STAR)
				require :RP
				:PI
			when :POW												then args = one_or_more { expr }
			when :POWER											then args = one_or_more { expr }
			when :PRINTF										then args = one_or_more { expr }
			when :QUOTE											then arg = expr
			when :RADIANS										then arg = expr
			when :RANDOM 										then arg = maybe(:STAR)
			when :RANDOMBLOB								then arg = expr
			when :REPLACE										then args = one_or_more { expr }
			when :ROUND											then args = one_or_more { expr }
			when :RTRIM											then args = one_or_more { expr }
			when :SIGN											then arg = expr
			when :SIN												then arg = expr
			when :SINH											then arg = expr
			when :SOUNDEX										then arg = expr
			when :SQLITE_COMPILEOPTION_GET	then arg = expr
			when :SQLITE_COMPILEOPTION_USED	then arg = expr
			when :SQLITE_OFFSET							then arg = expr
			when :SQLITE_SOURCE_ID
				maybe(:STAR)
				require :RP
				:SQLITE_SOURCE_ID
			when :SQLITE_VERSION
				maybe(:STAR)
				require :RP
				:SQLITE_VERSION
			when :SQRT											then arg = expr
			when :STRFTIME									then args = one_or_more { expr }
			when :SUBSTR										then args = one_or_more { expr }
			when :SUBSTRING									then args = one_or_more { expr }
			when :TAN												then arg = expr
			when :TANH											then arg = expr
			when :TIME											then args = one_or_more { expr }
			when :TIMEDIFF									then args = one_or_more { expr }
			when :TOTAL_CHANGES
				maybe(:STAR)
				require :RP
				:TOTAL_CHANGES
			when :TRIM											then args = one_or_more { expr }
			when :TRUNC											then arg = expr
			when :TYPEOF										then arg = expr
			when :UNHEX											then args = one_or_more { expr }
			when :UNICODE										then arg = expr
			when :UNIXEPOCH									then args = one_or_more { expr }
			when :UNLIKELY									then arg = expr
			when :UPPER											then arg = expr
			when :ZEROBLOB									then arg = expr
			else																	args = one_or_more { expr }
			end

			FunctionReference.new(
				function_name: func,
				arguments: args,
			)
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
				args = [:*]
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
			require :RP
			filter = optional { filter_clause }

			FunctionReference.new(
				function_name: func,
				arguments: args,
				filter_clause: filter,
			)
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
	end
end
