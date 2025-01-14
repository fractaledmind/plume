# frozen_string_literal: true

module Plume
	class CheckColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :expression, Expression
	end
end
