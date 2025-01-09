# frozen_string_literal: true

# ◯─▶{ CREATE }┬───────▶──────┬▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
#              ├▶{ TEMP }─────┤          │                             │
#              └▶{ TEMPORARY }┘          │                             │
# ┌─────────────────────◀────────────────┴──────────────────◀──────────┘
# ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }┬───────▶{ AS }─▶[ select-stmt ]───▶─────┐
# └────────▶────────────────┘               │                                        │
# ┌────────────────────◀────────────────────┘                     ┌────────▶─────────┼─▶◯
# └▶{ ( }─┬▶[ column-def ]─┬▶┬─────────────────────────────┬▶{ ) }┴▶[ table-options ]┘
#         └─────{ , }◀─────┘ └[ table-constraint ]◀─{ , }◀─┘

module Plume
	class Parser
		def CreateTableStatement
			accept :CREATE
			temporary = maybe(:TEMP) or maybe(:TEMPORARY)
			accept :TABLE
			if_not_exists = maybe_all(:IF, :NOT, :EXISTS)
			schema_name, table_name = table_ref

			if maybe :AS
			# TODO
			elsif maybe :LP
				columns = one_or_more { column_def }
				constraints = zero_or_more { table_constraint }
				accept :RP
			else
				error!(current_token, current_value, [:AS, :LP])
			end

			CreateTableStatement.new(
				schema_name:,
				table_name:,
				temporary: (true if temporary),
				if_not_exists: (true if if_not_exists),
				columns:
			)
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
				direction = maybe(:ASC) || maybe(:DESC)
				on_conflict = conflict_clause
				autoincrement = maybe(:AUTOINCR)

				PrimaryKeyColumnConstraint.new(
					name:,
					direction:,
					autoincrement: (true if autoincrement),
					conflict_clause: on_conflict
				)
			elsif maybe_all :NOT, :NULL
				on_conflict = conflict_clause

				if on_conflict or name
					{ NOT_NULL: [true, on_conflict, ({ NAME: name } if name)].compact! }
				else
					{ NOT_NULL: true }
				end
			elsif maybe :UNIQUE
				on_conflict = conflict_clause

				if on_conflict or name
					{ UNIQUE: [true, on_conflict, ({ NAME: name } if name)].compact! }
				else
					{ UNIQUE: true }
				end
			elsif maybe :CHECK
				accept :LP
				check = expr
				accept :RP
				if name
					{ CHECK: [check, { NAME: name }] }
				else
					{ CHECK: check }
				end
			elsif maybe :DEFAULT
				if maybe :LP
					default = expr
					accept :RP
					{ DEFAULT: default }
				elsif (number = optional { signed_number })
					{ DEFAULT: number }
				elsif (value = optional { literal_value })
					{ DEFAULT: value }
				else
					error!(current_token, current_value, [:LP, "literal-value", "signed-number"])
				end
			elsif maybe :COLLATE
				{ COLLATE: identifier }
			elsif :REFERENCES == current_token
				foreign_key_clause
			elsif maybe_all(:GENERATED, :ALWAYS, :AS) or maybe(:AS)
				accept :LP
				default = expr
				accept :RP
				if maybe :STORED
					{ GENERATED_AS: [default, :STORED] }
				elsif maybe :VIRTUAL
					{ GENERATED_AS: [default, :VIRTUAL] }
				else
					{ GENERATED_AS: default }
				end
			else
				# TODO: error here
			end
		end

		def type_name
			# ◯─┬▶{ name }─┬┬──────────────────────────────▶─────────────────────────────┬─▶◯
			#   └────◀─────┘├─▶{ ( }─▶[ signed-number ]─▶{ ) }─────────────────────────▶─┤
			#               └─▶{ ( }─▶[ signed-number ]─▶{ , }─▶[ signed-number ]─▶{ ) }─┘
			name = one_or_more(sep: nil) { identifier }.join(" ")
			if maybe :LP
				constraints = one_or_more { signed_number }
				accept :RP
			end

			case name
			when /INT/i							then	IntegerType.new(name:, constraints:)
			when /CHAR|CLOB|TEXT/i	then	TextType.new(name:, constraints:)
			when /BLOB/i						then	BlobType.new(name:, constraints:)
			when /REAL|FLOA|DOUB/i	then	RealType.new(name:, constraints:)
			else													AnyType.new(name:, constraints:)
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
