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
		token :create_kw, required: true
		token :temp_kw, required: false
		token :table_kw, required: true
		token :if_not_exists_kw, required: false
		token :schema_name, required: false, inspect: true
		token :table_name, required: true, inspect: true
		token :as_kw, required: false
		token :columns_lp, required: false
		token :columns_rp, required: false
		node :select_statement, _Any, required: false
		node :columns, ColumnDefinition, required: false, collection: true
		node :constraints, TableConstraint, required: false, collection: true
		node :options, TableOption, required: false, collection: true

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
