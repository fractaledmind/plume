# frozen_string_literal: true

module Plume
	class ColumnDefinition < Node
		prop :name, String
		prop :type_name, _Nilable(Type)
		prop :constraints, _Nilable(_Array(ColumnConstraint))
	end
end