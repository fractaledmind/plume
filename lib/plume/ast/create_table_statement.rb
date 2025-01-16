# frozen_string_literal: true

module Plume
	# - `schema_name` → `_Nilable(String)`
	# - `table_name` → `String`
	# - `select_statement` → `_Nilable(SelectStatement)`
	# - `columns` → `_Array(ColumnDefinition)`
	# - `strict` → `_Nilable(_Boolean)`
	# - `temporary` → `_Nilable(_Boolean)`
	# - `if_not_exists` → `_Nilable(_Boolean)`
	# - `without_row_id` → `_Nilable(_Boolean)`
	# - `constraints` → `_Array(TableConstraint)`
	#
	# ```
	# ◯─▶{ CREATE }┬───────▶──────┬▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
	#              ├▶{ TEMP }─────┤          │                             │
	#              └▶{ TEMPORARY }┘          │                             │
	# ┌─────────────────────◀────────────────┴──────────────────◀──────────┘
	# ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }┬───────▶{ AS }─▶[ select-stmt ]───▶─────┐
	# └────────▶────────────────┘               │                                        │
	# ┌────────────────────◀────────────────────┘                     ┌────────▶─────────┼─▶◯
	# └▶{ ( }─┬▶[ column-def ]─┬▶┬─────────────────────────────┬▶{ ) }┴▶[ table-options ]┘
	#         └─────{ , }◀─────┘ └[ table-constraint ]◀─{ , }◀─┘
	# ```
	#
	# **[SQLite Docs](https://www.sqlite.org/lang_createtable.html)**
	#
	# ```sql
	# create table tb0 (c0 primary key desc on conflict abort autoincrement)
	# ```
	class CreateTableStatement < Node
		prop :schema_name, _Nilable(String)
		prop :table_name, String
		prop :select_statement, _Nilable(_Any)
		prop :columns, _Nilable(_Array(ColumnDefinition))
		prop :strict, _Nilable(_Boolean)
		prop :temporary, _Nilable(_Boolean)
		prop :if_not_exists, _Nilable(_Boolean)
		prop :without_row_id, _Nilable(_Boolean)
		prop :constraints, _Nilable(_Array(TableConstraint))

		def after_initialize
			raise ArgumentError unless (!!@select_statement ^ @columns&.any?)
			raise ArgumentError if @select_statement && (@strict || @without_row_id)
		end
	end
end
