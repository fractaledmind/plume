# frozen_string_literal: true

module Plume
	class TableName < Node
		optional_token :schema_tk,
			reader: :schema,
			default: -> { schema_tk_val }
		optional_token :dot_tk
		required_token :table_tk,
			reader: :table,
			default: -> { table_tk_val }

		alias_method :name, :table
	end
end
