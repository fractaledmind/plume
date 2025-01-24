# frozen_string_literal: true

module Plume
	class ColumnReference < Node
		prop :schema_name, _Nilable(String)
		prop :table_name, _Nilable(String)
		prop :name, String
	end
end
