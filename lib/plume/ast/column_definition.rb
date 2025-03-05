# frozen_string_literal: true

module Plume
	class ColumnDefinition < Node
		required_token :name, inspect: true

		optional_node :type, ColumnType
		optional_nodes :constraints, ColumnConstraint
	end
end
