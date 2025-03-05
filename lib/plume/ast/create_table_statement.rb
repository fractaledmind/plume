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
	# **[SQLite Docs](https://www.sqlite.org/lang_createtable.html)**
	#
	# ```sql
	# create table tb0 (c0 primary key desc on conflict abort autoincrement)
	# ```
	class CreateTableStatement < Node
		required_token :create_kw
		optional_token :temp_kw
		required_token :table_kw
		optional_token :if_not_exists_kw
		required_node  :table,           TableName
		optional_token :columns_lp
		optional_nodes :columns,         ColumnDefinition
		optional_nodes :constraints,     TableConstraint
		optional_token :columns_rp
		optional_nodes :options,         TableOption

		optional_token :as_kw
		optional_node :select_statement, _Any

		inspectable def temporary      = !!@temp_kw
		inspectable def if_not_exists  = !!@if_not_exists_kw
		inspectable def strict         = @options&.any?(StrictTableOption)
		inspectable def without_row_id = @options&.any?(WithoutRowidTableOption)
	end
end
