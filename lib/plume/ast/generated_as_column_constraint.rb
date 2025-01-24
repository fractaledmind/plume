# frozen_string_literal: true

module Plume
	class GeneratedAsColumnConstraint < ColumnConstraint
		Type = _Union(:STORED, :VIRTUAL)

		required_node :expression, Expression

		optional_node :type, Type

		optional_token :name, inspect: true
	end
end
