# frozen_string_literal: true

module Plume
	class DefaultColumnConstraint < ColumnConstraint
		Value = _Union(LiteralValue, SignedNumber, Expression)

		required_node :value, Value

		optional_token :name, inspect: true
	end
end
