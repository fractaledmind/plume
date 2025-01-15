# frozen_string_literal: true

module Plume
	class Parser
		def CreateTableStatement
			# ◯─▶{ CREATE }┬───────▶──────┬▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
			#              ├▶{ TEMP }─────┤          │                             │
			#              └▶{ TEMPORARY }┘          │                             │
			# ┌─────────────────────◀────────────────┴──────────────────◀──────────┘
			# ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }┬───────▶{ AS }─▶[ select-stmt ]───▶─────┐
			# └────────▶────────────────┘               │                                        │
			# ┌────────────────────◀────────────────────┘                     ┌────────▶─────────┼─▶◯
			# └▶{ ( }─┬▶[ column-def ]─┬▶┬─────────────────────────────┬▶{ ) }┴▶[ table-options ]┘
			#         └─────{ , }◀─────┘ └[ table-constraint ]◀─{ , }◀─┘

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
				constraints = zero_or_more { table_constraint }
				require :RP
				options = optional { table_options } # nil || [:STRICT, true] || [true] || [:STRICT]

				CreateTableStatement.new(
					schema_name:,
					table_name:,
					temporary: (true if temporary),
					if_not_exists: (true if if_not_exists),
					strict: (true if options&.include?(:STRICT)),
					without_row_id: (true if options&.include?(true)),
					columns:
				)
			else
				expected!(:AS, :LP)
			end
		end

		# layer 1

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
			#    ├─▶{ PRIMARY }─▶{ KEY }──┬▶{ ( }┬▶[ indexed-column ]┬▶{ ) }─▶[ conflict-clause ]───┬─▶◯
			#    ├─▶{ UNIQUE }─────────▶──┘      └───────{ , }◀──────┘                              │
			#    ├─▶{ CHECK }─▶{ ( }─▶[ expr ]─▶{ ) }─────────────────────────────────────────────▶─┤
			#    ├─▶[ foreign-key-clause ]────────────────────────────────────────────────────────▶─┤
			#    └─▶{ FOREIGN }─▶{ KEY }─▶{ ( }┬▶{ column-name }┬▶{ ) }─▶[ foreign-key-clause ]───▶─┘
			#                                  └─────{ , }◀─────┘
			name = identifier if maybe :CONSTRAINT
			if maybe :UNIQUE
				require :LP
				columns = one_or_more { indexed_column }
				require :RP
				on_conflict = conflict_clause
				if on_conflict or name
					{ UNIQUE: [columns, on_conflict, ({ NAME: name } if name)].compact! }
				else
					{ UNIQUE: columns }
				end
			elsif maybe :CHECK
				require :LP
				check = expr
				require :RP
				{ CHECK: check }
			elsif maybe_all :PRIMARY, :KEY
				require :LP
				columns = one_or_more { indexed_column }
				require :RP
				on_conflict = conflict_clause
				if on_conflict or name
					{ PRIMARY_KEY: [columns, on_conflict, ({ NAME: name } if name)].compact! }
				else
					{ PRIMARY_KEY: columns }
				end
			elsif maybe_all :FOREIGN, :KEY
				require :LP
				columns = one_or_more { column_name }
				require :RP
				clause = foreign_key_clause
				{ FOREIGN_KEY: [columns, clause] }
			else
				expected!(:CONSTRAINT, :PRIMARY, :UNIQUE, :CHECK, :FOREIGN)
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
			elsif maybe :UNIQUE
				on_conflict = conflict_clause

				UniqueColumnConstraint.new(
					name:,
					conflict_clause: on_conflict
				)
			elsif maybe :CHECK
				require :LP
				check = expr
				require :RP

				CheckColumnConstraint.new(
					name:,
					expression: check
				)
			elsif maybe :DEFAULT
				if maybe :LP
					value = expr
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
				else
					expected!(:LP, "literal-value", "signed-number")
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
				default = expr
				require :RP
				type = either(:STORED, :VIRTUAL, nil)

				GeneratedAsColumnConstraint.new(
					name:,
					expression: default,
					type:,
				)
			else
				expected!(:PRIMARY, :NOT, :NULL, :UNIQUE, :CHECK, :DEFAULT, :COLLATE, :REFERENCES, :GENERATED)
			end
		end

		def indexed_column
			# ◯─▶┬▶{ column-name }─┬┬─▶───────────────────────────────┬┬────────▶───┬────▶◯
			#    └▶[ expr ]─────▶──┘└─▶{ COLLATE }─▶{ collation-name }┘├─▶{ ASC }─▶─┤
			#                                                          └─▶{ DESC }──┘
			if :ID == current_token
				name = identifier
			elsif (e = optional { expr })
				# no-op
			else
				expected!(:ID, "expr")
			end
			collation = nil
			if maybe :COLLATE
				collation = identifier
			end
			direction = either(:ASC, :DESC, nil)

			if name && collation && direction
				{ ColumnRef[name] => [collation, direction] }
			elsif name && collation
				{ ColumnRef[name] => collation }
			elsif name && direction
				{ ColumnRef[name] => direction }
			elsif name
				ColumnRef[name]
			elsif e && collation && direction
				{ e => [collation, direction] }
			elsif e && collation
				{ e => collation }
			elsif e && direction
				{ e => direction }
			elsif e
				e
			else
				expected!(:ID, "expr")
			end
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
					expected!(:ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE)
				end
			end
		end
	end

	class Generator
		def CreateTableStatement(node)
		end
	end

	class Deserializer
		def CreateTableStatement
		end
	end

	class Serializer
		def CreateTableStatement(node)
		end
	end
end
