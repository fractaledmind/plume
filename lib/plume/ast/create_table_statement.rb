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
		token :create_kw
		token :temp_kw
		token :table_kw
		token :if_not_exists_kw
		token :columns_lp
		token :columns_rp
		token :as_kw

		attr :temporary, _Boolean
		attr :if_not_exists, _Boolean
		node  :table,           TableName
		nodes :columns,         ColumnDefinition
		nodes :constraints,     TableConstraint
		nodes :options,         TableOption

		node :select_statement, _Any

		def self.new(*, table:, **) = super
		def self.concrete(*, create_kw:, table_kw:, **) = super

		def table = (@table == LiteralNil) ? table_tk_val : @table
		def temporary = (@temporary == LiteralNil) ? !!@temp_kw : @temporary
		def if_not_exists = (@if_not_exists == LiteralNil) ? !!@if_not_exists_kw : @if_not_exists

		inspectable def strict         = (@options != LiteralNil) ? @options&.any?(StrictTableOption) : false
		inspectable def without_row_id = (@options != LiteralNil) ? @options&.any?(WithoutRowidTableOption) : false
	end
end
