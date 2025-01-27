# frozen_string_literal: true

module Plume
	class DefaultColumnConstraint < ColumnConstraint
		Value = _Union(LiteralValue, SignedNumber, Expression)

		prop :name, _Nilable(String)
		prop :value, Value
	end
end
