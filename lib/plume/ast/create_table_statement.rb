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
		optional_node :select_statement, _Any
		optional_nodes :columns, ColumnDefinition
		optional_nodes :constraints, TableConstraint
		optional_nodes :options, TableOption

		required_token :table_name, inspect: true
		required_token :create_kw
		required_token :table_kw

		optional_token :schema_name, inspect: true
		optional_token :as_kw
		optional_token :columns_lp
		optional_token :columns_rp
		optional_token :if_not_exists_kw
		optional_token :temp_kw

		inspectable def temporary = !!@temp_kw
		inspectable def if_not_exists = !!@if_not_exists_kw
		inspectable def strict = @options&.any?(StrictTableOption)
		inspectable def without_row_id = @options&.any?(WithoutRowidTableOption)

		def after_initialize
			raise ArgumentError unless (!!@select_statement ^ @columns&.any?)
			raise ArgumentError if @select_statement && (@strict || @without_row_id)
		end
	end
end
