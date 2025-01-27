# frozen_string_literal: true

module Plume
	class GeneratedAsColumnConstraint < ColumnConstraint
		Type = _Union(:STORED, :VIRTUAL)

		prop :name, _Nilable(String)
		prop :expression, Expression
		prop :type, _Nilable(Type)
	end
end
