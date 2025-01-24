# frozen_string_literal: true

module Plume
	class ColumnDefinition < Node
		token :name, required: true, inspect: true
		node :type, Type, required: false
		node :constraints, ColumnConstraint, required: false, collection: true
	end
end
