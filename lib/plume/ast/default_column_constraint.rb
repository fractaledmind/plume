# frozen_string_literal: true

module Plume
	class DefaultColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :value, _Union(LiteralValue, SignedNumber, Expression)
	end
end
