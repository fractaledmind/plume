# frozen_string_literal: true

module Plume
	class GeneratedAsColumnConstraint < ColumnConstraint
		Type = _Union(:STORED, :VIRTUAL)

		optional_token :name, inspect: true
		prop :expression, Expression
		prop :type, _Nilable(Type)
	end
end
