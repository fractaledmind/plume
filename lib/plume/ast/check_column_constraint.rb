# frozen_string_literal: true

module Plume
	class CheckColumnConstraint < ColumnConstraint
		required_node :expression, Expression

		optional_token :name, inspect: true
	end
end
