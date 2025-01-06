# frozen_string_literal: true

require "date"

module Plume
	class Statement
		def self.sql(statement)
			new(statement).sql
		end

		def initialize(statement)
			@statement = statement
		end

		def sql
			raise ArgumentError, "Invalid statement" unless @statement.is_a?(Hash)

			@statement.to_a.map do |part|
				to_sql(part)
			end.join(" ")
		end

		private

		def to_sql(part)
			case part
			in [:SELECT, Array => selections]
				"SELECT #{selections.map { |s| result_column(s) }.join(", ")}"
			in [:SELECT, { DISTINCT: Array => selections}]
				"SELECT DISTINCT #{selections.map { |s| result_column(s) }.join(", ")}"
			in [:SELECT, { ALL: Array => selections}]
				"SELECT ALL #{selections.map { |s| result_column(s) }.join(", ")}"
			in [:SELECT, { DISTINCT: selection}]
				"SELECT DISTINCT #{result_column(selection)}"
			in [:SELECT, { ALL: selection}]
				"SELECT ALL #{result_column(selection)}"
			in [:SELECT, selection]
				"SELECT #{result_column(selection)}"
			in [:FROM, Array => sources]
				"FROM #{sources.map { |it| "(#{source(it)})" }.join(", ")}"
			in [:FROM, source]
				"FROM #{source(source)}"
			in [:WHERE, Array => conditions]
				"WHERE #{e({ ALL: conditions })}"
			in [:WHERE, Hash => condition]
				"WHERE #{e(condition)}"
			in [:GROUP_BY, Array => exprs]
				"GROUP BY #{_e(exprs)}"
			in [:GROUP_BY, expr]
				"GROUP BY #{e(expr)}"
			in [:HAVING, expr]
				"HAVING #{e(expr)}"
			in [:ORDER_BY, Array => exprs]
				"ORDER BY #{exprs.map { |it| ordering(it) }.join(", ")}"
			in [:ORDER_BY, Hash => ordering]
				"ORDER BY #{ordering(ordering)}"
			in [:LIMIT, Range => range]
				if range.begin
					limit = if range.end
						if range.exclude_end?
							range.end - range.begin - 1
						else
							range.end - range.begin
						end
					else
						-1
					end
					offset = range.begin

					"LIMIT #{limit} OFFSET #{offset}"
				else
					limit = if range.exclude_end?
						range.end - 1
					else
						range.end
					end

					"LIMIT #{limit}"
				end
			in [:LIMIT, Array[limit, { OFFSET: offset }]]
				"LIMIT #{e(limit)} OFFSET #{e(offset)}"
			in [:LIMIT, limit]
				"LIMIT #{e(limit)}"
			else part
			end
		end

		def source(source)
			case source
			in { INNER_JOIN: Array[left, right], ON: expr, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} INNER JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { INNER_JOIN: Array[left, right], USING: Array => columns, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} INNER JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { INNER_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} INNER JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { INNER_JOIN: Array[left, right], ON: expr }
				"#{table_or_subquery(left)} INNER JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { INNER_JOIN: Array[left, right], USING: Array => columns }
				"#{table_or_subquery(left)} INNER JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { INNER_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column }
				"#{table_or_subquery(left)} INNER JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { INNER_JOIN: Array[left, right], NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} INNER JOIN #{table_or_subquery(right)}"
			in { INNER_JOIN: Array[left, right] }
				"#{table_or_subquery(left)} INNER JOIN #{table_or_subquery(right)}"
			in { LEFT_JOIN: Array[left, right], ON: expr, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} LEFT JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { LEFT_JOIN: Array[left, right], USING: Array => columns, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} LEFT JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { LEFT_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} LEFT JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { LEFT_JOIN: Array[left, right], ON: expr }
				"#{table_or_subquery(left)} LEFT JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { LEFT_JOIN: Array[left, right], USING: Array => columns }
				"#{table_or_subquery(left)} LEFT JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { LEFT_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column }
				"#{table_or_subquery(left)} LEFT JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { LEFT_JOIN: Array[left, right], NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} LEFT JOIN #{table_or_subquery(right)}"
			in { LEFT_JOIN: Array[left, right] }
				"#{table_or_subquery(left)} LEFT JOIN #{table_or_subquery(right)}"
			in { RIGHT_JOIN: Array[left, right], ON: expr, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} RIGHT JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { RIGHT_JOIN: Array[left, right], USING: Array => columns, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} RIGHT JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { RIGHT_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} RIGHT JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { RIGHT_JOIN: Array[left, right], ON: expr }
				"#{table_or_subquery(left)} RIGHT JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { RIGHT_JOIN: Array[left, right], USING: Array => columns }
				"#{table_or_subquery(left)} RIGHT JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { RIGHT_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column }
				"#{table_or_subquery(left)} RIGHT JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { RIGHT_JOIN: Array[left, right], NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} RIGHT JOIN #{table_or_subquery(right)}"
			in { RIGHT_JOIN: Array[left, right] }
				"#{table_or_subquery(left)} RIGHT JOIN #{table_or_subquery(right)}"
			in { FULL_JOIN: Array[left, right], ON: expr, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} FULL JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { FULL_JOIN: Array[left, right], USING: Array => columns, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} FULL JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { FULL_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column, NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} FULL JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { FULL_JOIN: Array[left, right], ON: expr }
				"#{table_or_subquery(left)} FULL JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { FULL_JOIN: Array[left, right], USING: Array => columns }
				"#{table_or_subquery(left)} FULL JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { FULL_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column }
				"#{table_or_subquery(left)} FULL JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { FULL_JOIN: Array[left, right], NATURAL: natural }
				"#{table_or_subquery(left)}#{' NATURAL' if natural} FULL JOIN #{table_or_subquery(right)}"
			in { FULL_JOIN: Array[left, right] }
				"#{table_or_subquery(left)} FULL JOIN #{table_or_subquery(right)}"
			in { CROSS_JOIN: Array[left, right], ON: expr }
				"#{table_or_subquery(left)} CROSS JOIN #{table_or_subquery(right)} ON #{e(expr)}"
			in { CROSS_JOIN: Array[left, right], USING: Array => columns }
				"#{table_or_subquery(left)} CROSS JOIN #{table_or_subquery(right)} USING (#{_e(columns)})"
			in { CROSS_JOIN: Array[left, right], USING: ColumnRef | String | Symbol => column }
				"#{table_or_subquery(left)} CROSS JOIN #{table_or_subquery(right)} USING (#{e(column)})"
			in { CROSS_JOIN: Array[left, right] }
				"#{table_or_subquery(left)} CROSS JOIN #{table_or_subquery(right)}"
			else
				table_or_subquery(source)
			end
		end

		def ordering(ordering)
			key, value = ordering.first

			order_by = case key
				in Array[expr, collation]
					e({ expr => { COLLATE: collation } })
				else
					e(key)
				end

			order_in = case value
				in Array[:ASC | :asc, nil]
					"ASC NULLS LAST"
				in Array[:DESC | :desc, nil]
					"DESC NULLS LAST"
				in Array[Range => range, nil]
					if range.begin < range.end
						"ASC NULLS LAST"
					elsif range.begin > range.end
						"DESC NULLS LAST"
					else
						raise ArgumentError.new("Cannot order by range with equal start and end: `#{range}`!")
					end
				in Array[nil, :ASC | :asc]
					"ASC NULLS FIRST"
				in Array[nil, :DESC | :desc]
					"DESC NULLS FIRST"
				in Array[nil, Range => range]
					if range.begin < range.end
						"ASC NULLS FIRST"
					elsif range.begin > range.end
						"DESC NULLS FIRST"
					else
						raise ArgumentError.new("Cannot order by range with equal start and end: `#{range}`!")
					end
				in :ASC | :asc
					"ASC"
				in :DESC | :desc
					"DESC"
				in Range => range
					if range.begin < range.end
						"ASC"
					elsif range.begin > range.end
						"DESC"
					else
						raise ArgumentError.new("Cannot order by range with equal start and end: `#{range}`!")
					end
				end

			[order_by, order_in].join(" ")
		end

		def result_column(struct)
			case struct
			in :* then "*"
			in ColumnRef => ref then ref.to_s
			in Hash => struct if struct.size == 1
				expr, as = struct.first
				"#{e(expr)} AS '#{as}'"
			else
				e(struct)
			end
		end

		def table_or_subquery(struct)
			case struct
			in ColumnRef then struct.to_s
			in Hash if struct.size == 1
				case (entry = struct.first)
				in [ColumnRef => ref, { INDEXED_BY: index_name }]
					"#{ref} INDEXED BY #{index_name}"
				in [ColumnRef => ref, :NOT_INDEXED]
					"#{ref} NOT INDEXED"
				in [ColumnRef => ref, alias_name]
					"#{ref} AS '#{alias_name}'"
				in [:SELECT, statement]
					"(#{s(struct)})"
				in [Hash => singlet, alias_name] if singlet.size == 1
					case singlet.first
					in [:SELECT, selections]
						"(#{s(singlet)}) AS '#{alias_name}'"
					else
						"#{e(singlet)} AS '#{alias_name}'"
					end
				else
					e(struct)
				end
			end
		end

		def e(expression)
			Expression.sql(expression)
		end

		def s(expression)
			Statement.sql(expression)
		end

		def _s(statements)
			statements.map { |it| s(it) }.join(', ')
		end

		def _e(expressions)
			expressions.map { |it| e(it) }.join(', ')
		end
	end

	class Expression
		def self.sql(expression)
			new(expression).sql
		end

		def initialize(expression)
			@expression = expression
		end

		def sql
			case @expression
			in Expression																then @expression.sql
			in ColumnRef 																then @expression.to_s
			in nil	 																		then "NULL"
			in true 																		then "TRUE"
			in false 																		then "FALSE"
			in :CURRENT_TIME 														then "CURRENT_TIME"
			in :CURRENT_DATE 														then "CURRENT_DATE"
			in :CURRENT_TIMESTAMP 											then "CURRENT_TIMESTAMP"
			in :CHANGES 																then "CHANGES()"
			in :LAST_INSERT_ROWID 											then "LAST_INSERT_ROWID()"
			in :RANDOM 																	then "RANDOM()"
			in :SQLITE_SOURCE_ID 												then "SQLITE_SOURCE_ID()"
			in :SQLITE_VERSION 													then "SQLITE_VERSION()"
			in :TOTAL_CHANGES 													then "TOTAL_CHANGES()"
			in String 																	then "'#{@expression}'"
			in Float 																		then @expression.to_s
			in Integer 																	then @expression.to_s
			in Symbol 																	then @expression.inspect
			in IO 																			then hex(@expression)
			in Date 																		then "'#{@expression.iso8601}'"
			in DateTime 																then "'#{@expression.iso8601}'"
			in Time 																		then "'#{@expression.strftime("%H:%M:%S.%L")}'"
			in { NEGATE: expr } 												then "-(#{_ expr})"
			in { INVERT: expr } 												then "~(#{_ expr})"
			in { ABS: expr } 														then "ABS(#{_ expr})"
			in { CHAR: Array => args } 									then "CHAR(#{__ args})"
			in { COALESCE: Array => args } 							then "COALESCE(#{__ args})"
			in { CONCAT: Array => args } 								then "CONCAT(#{__ args})"
			in { CONCAT_WS: Array[sep, *args] } 				then "CONCAT_WS(#{_ sep}, #{__ args})"
			in { FORMAT: Array[format, *args] } 				then "FORMAT(#{_ format}, #{__ args})"
			in { GLOB: Array[_, _] => args } 						then "GLOB(#{__ args})"
			in { HEX: expr } 														then "HEX(#{_ expr})"
			in { IFNULL: Array[_, _] => args } 					then "IFNULL(#{__ args})"
			in { IIF: Array[_, _, _] } 									then "IIF(#{__ args})"
			in { INSTR: Array[_, _] => args } 					then "INSTR(#{__ args})"
			in { LENGTH: expr } 												then "LENGTH(#{_ expr})"
			in { LIKE: Array[_, _] => args } 						then "LIKE(#{__ args})"
			in { LIKE: Array[_, _, _] } 								then "LIKE(#{__ args})"
			in { LIKELIHOOD: Array[_, _] => args } 			then "LIKELIHOOD(#{__ args})"
			in { LIKELY: expr } 												then "LIKELY(#{_ expr})"
			in { LOAD_EXTENSION: Array[_, _] => args } 	then "LOAD_EXTENSION(#{__ args})"
			in { LOAD_EXTENSION: expr } 								then "LOAD_EXTENSION(#{_ expr})"
			in { LOWER: expr } 													then "LOWER(#{_ expr})"
			in { LTRIM: Array[_, _] => args } 					then "LTRIM(#{__ args})"
			in { LTRIM: expr } 													then "LTRIM(#{_ expr})"
			in { MAX: Array => args } 									then "MAX(#{__ args})"
			in { MIN: Array => args } 									then "MIN(#{__ args})"
			in { NULLIF: Array[_, _] => args } 					then "NULLIF(#{__ args})"
			in { OCTET_LENGTH: expr } 									then "OCTET_LENGTH(#{_ expr})"
			in { PRINTF: Array[format, *args] } 				then "PRINTF(#{_ format}, #{__ args})"
			in { QUOTE: expr } 													then "QUOTE(#{_ expr})"
			in { RANDOMBLOB: expr } 										then "RANDOMBLOB(#{_ expr})"
			in { REPLACE: Array[_, _, _] } 							then "REPLACE(#{__ args})"
			in { ROUND: Array[_, _] => args } 					then "ROUND(#{__ args})"
			in { ROUND: expr } 													then "ROUND(#{_ expr})"
			in { RTRIM: Array[_, _] => args } 					then "RTRIM(#{__ args})"
			in { RTRIM: expr } 													then "RTRIM(#{_ expr})"
			in { SIGN: expr } 													then "SIGN(#{_ expr})"
			in { SOUNDEX: expr } 												then "SOUNDEX(#{_ expr})"
			in { SQLITE_COMPILEOPTION_GET: expr } 			then "SQLITE_COMPILEOPTION_GET(#{_ expr})"
			in { SQLITE_COMPILEOPTION_USED: expr } 			then "SQLITE_COMPILEOPTION_USED(#{_ expr})"
			in { SQLITE_OFFSET: expr } 									then "SQLITE_OFFSET(#{_ expr})"
			in { SUBSTR: Array[_, _] => args } 					then "SUBSTR(#{__ args})"
			in { SUBSTR: Array[_, _, _] } 							then "SUBSTR(#{__ args})"
			in { SUBSTRING: Array[_, _] => args } 			then "SUBSTRING(#{__ args})"
			in { SUBSTRING: Array[_, _, _] } 						then "SUBSTRING(#{__ args})"
			in { TRIM: Array[_, _] => args } 						then "TRIM(#{__ args})"
			in { TRIM: expr } 													then "TRIM(#{_ expr})"
			in { TYPEOF: expr } 												then "TYPEOF(#{_ expr})"
			in { UNHEX: Array[_, _] => args } 					then "UNHEX(#{__ args})"
			in { UNHEX: expr } 													then "UNHEX(#{_ expr})"
			in { UNICODE: expr } 												then "UNICODE(#{_ expr})"
			in { UNLIKELY: expr } 											then "UNLIKELY(#{_ expr})"
			in { UPPER: expr } 													then "UPPER(#{_ expr})"
			in { ZEROBLOB: expr } 											then "ZEROBLOB(#{_ expr})"
			in { JSON_EACH: ColumnRef => ref } 					then "JSON_EACH(#{ref})"
			in { FN: Hash => struct }
				fn, args = struct.first
				args.nil? ? "#{_ fn}()" : "#{_ fn}(#{__ args})"
			in { ANY: Array => exprs }
				"(#{exprs.map { |it| _(it) }.join(' OR ')})"
			in { ALL: Array => exprs }
				"(#{exprs.map { |it| _(it) }.join(' AND ')})"
			in Hash => struct if struct.size == 1
				entry = struct.first
				case entry
				in [lexpr, nil]
					"#{_ lexpr} ISNULL"
				in [lexpr, { CAST: type_name }]
					"CAST(#{_ lexpr} AS #{type_name})"
				in [lexpr, { COLLATE: :BINARY | "BINARY" | :binary | "binary" }]
					"#{_ lexpr} COLLATE BINARY"
				in [lexpr, { COLLATE: :NOCASE | "NOCASE" | :nocase | "nocase" }]
					"#{_ lexpr} COLLATE NOCASE"
				in [lexpr, { COLLATE: :RTRIM | "RTRIM" | :rtrim | "rtrim" }]
					"#{_ lexpr} COLLATE RTRIM"
				in [lexpr, { CONCAT: rexpr }]
					"#{_ lexpr} || #{_ rexpr}"
				in [lexpr, { EXTRACT: rexpr }]
					"#{_ lexpr} -> #{_ rexpr}"
				in [lexpr, { RETRIEVE: rexpr }]
					"#{_ lexpr} ->> #{_ rexpr}"
				in [lexpr, { MULTIPLY: rexpr }]
					"#{_ lexpr} * #{_ rexpr}"
				in [lexpr, { DIVIDE: rexpr }]
					"#{_ lexpr} / #{_ rexpr}"
				in [lexpr, { MODULO: rexpr }]
					"#{_ lexpr} % #{_ rexpr}"
				in [lexpr, { ADD: rexpr }]
					"#{_ lexpr} + #{_ rexpr}"
				in [lexpr, { SUB: rexpr }]
					"#{_ lexpr} - #{_ rexpr}"
				in [lexpr, { BIT_AND: rexpr }]
					"#{_ lexpr} & #{_ rexpr}"
				in [lexpr, { BIT_OR: rexpr }]
					"#{_ lexpr} | #{_ rexpr}"
				in [lexpr, { BIT_LSHIFT: rexpr }]
					"#{_ lexpr} << #{_ rexpr}"
				in [lexpr, { BIT_RSHIFT: rexpr }]
					"#{_ lexpr} >> #{_ rexpr}"
				in [lexpr, { BELOW: rexpr }]
					"#{_ lexpr} < #{_ rexpr}"
				in [lexpr, { ABOVE: rexpr }]
					"#{_ lexpr} > #{_ rexpr}"
				in [lexpr, { ATMOST: rexpr }]
					"#{_ lexpr} <= #{_ rexpr}"
				in [lexpr, { ATLEAST: rexpr }]
					"#{_ lexpr} >= #{_ rexpr}"
				in [lexpr, { EQUALS: rexpr }]
					"#{_ lexpr} == #{_ rexpr}"
				in [lexpr, { NOT_EQUALS: rexpr }]
					"#{_ lexpr} != #{_ rexpr}"
				in [lexpr, { IS: nil }]
					"#{_ lexpr} ISNULL"
				in [lexpr, { IS_NOT: nil }]
					"#{_ lexpr} NOTNULL"
				in [lexpr, { IS: rexpr }]
					"#{_ lexpr} IS #{_ rexpr}"
				in [lexpr, { IS_NOT: rexpr }]
					"#{_ lexpr} IS NOT #{_ rexpr}"
				in [lexpr, { BETWEEN: [rexpr1, rexpr2] }]
					"#{_ lexpr} BETWEEN #{_(rexpr1)} AND #{_ rexpr2}"
				in [lexpr, { NOT_BETWEEN: [rexpr1, rexpr2] }]
					"#{_ lexpr} NOT BETWEEN #{_(rexpr1)} AND #{_ rexpr2}"
				in [lexpr, { IN: Array => rexpr }]
					"#{_ lexpr} IN (#{rexpr.map { |e| _(e) }.join(', ')})"
				in [lexpr, { NOT_IN: Array => rexpr }]
					"#{_ lexpr} NOT IN (#{rexpr.map { |e| _(e) }.join(', ')})"
				in [lexpr, { LIKE: rexpr }]
					"#{_ lexpr} LIKE #{_ rexpr}"
				in [lexpr, { NOT_LIKE: rexpr }]
					"#{_ lexpr} NOT LIKE #{_ rexpr}"
				in [lexpr, { GLOB: rexpr }]
					"#{_ lexpr} GLOB #{_ rexpr}"
				in [lexpr, { NOT_GLOB: rexpr }]
					"#{_ lexpr} NOT GLOB #{_ rexpr}"
				in [lexpr, { REGEXP: rexpr }]
					"#{_ lexpr} REGEXP #{_ rexpr}"
				in [lexpr, { NOT_REGEXP: rexpr }]
					"#{_ lexpr} NOT REGEXP #{_ rexpr}"
				in [lexpr, { MATCH: rexpr }]
					"#{_ lexpr} MATCH #{_ rexpr}"
				in [lexpr, { NOT_MATCH: rexpr }]
					"#{_ lexpr} NOT MATCH #{_ rexpr}"
				in [:CASE, Hash => branches]
					cases = branches.map { |w, t| w == :ELSE ? "ELSE (#{_ t})" : "WHEN (#{_ w}) THEN (#{_ t})" }
					"CASE #{cases.join(' ')} END"
				in [:CASE, Array[base, branches]]
					cases = branches.map { |w, t| w == :ELSE ? "ELSE (#{_ t})" : "WHEN (#{_ w}) THEN (#{_ t})" }
					"CASE #{_(base)} #{cases.join(' ')} END"
				in [:EXISTS, Hash => select_stmt]
					"EXISTS (#{s(select_stmt)})"
				in [:NOT_EXISTS, Hash => select_stmt]
					"NOT EXISTS (#{s(select_stmt)})"
				in [lexpr, Array => rexpr]
					"#{_ lexpr} IN (#{rexpr.map { |e| _(e) }.join(', ')})"
				in [lexpr, Range => range]
					if range.exclude_end? && range.begin && range.end
						"#{_ lexpr} >= #{_(range.begin)} AND #{_ lexpr} < #{_(range.end)}"
					elsif range.exclude_end? && range.begin
						"#{_ lexpr} >= #{_(range.begin)}"
					elsif range.exclude_end? && range.end
						"#{_ lexpr} < #{_(range.end)}"
					elsif range.begin && range.end
						"#{_ lexpr} BETWEEN #{_(range.begin)} AND #{_(range.end)}"
					elsif range.begin
						"#{_ lexpr} >= #{_(range.begin)}"
					elsif range.end
						"#{_ lexpr} <= #{_(range.end)}"
					end
				in [lexpr, rexpr]
					"#{_ lexpr} IS #{_ rexpr}"
				end
			end
		end

		private

		def _(expression)
			self.class.sql(expression)
		end

		def __(expressions)
			expressions.map { |it| _(it) }.join(', ')
		end

		def s(statement)
			Statement.sql(statement)
		end

		def hex(io, chunk_size = 1024)
			hex_chunks = +"X'"

			while chunk = io.read(chunk_size)
				hex_chunks << chunk.unpack('H*').first
			end
			hex_chunks << "'"

			hex_chunks
		end
	end
end
