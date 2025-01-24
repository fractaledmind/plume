# frozen_string_literal: true

module Plume
	class CollateColumnConstraint < ColumnConstraint
		required_node :collation_name, Symbol

		optional_token :name, inspect: true
	end
end
