# frozen_string_literal: true

module Plume
	class TableReference < Node
		prop :schema_name, _Nilable(String)
		prop :table_name, String
	end
end
