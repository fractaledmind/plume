# frozen_string_literal: true

module Plume
	class ColumnName < Node
		optional_token :schema_tk,
			reader: :schema,
			type: String,
			default: -> { schema_tk_val }
		optional_token :dot1
		optional_token :table_tk,
			reader: :table,
			type: String,
			default: -> { table_tk_val }
		optional_token :dot2
		required_token :column_tk,
			reader: :column,
			type: String,
			default: -> { column_tk_val }
	end
end
