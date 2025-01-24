# frozen_string_literal: true

module Plume
	class DefaultColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		prop :value, _Union(LiteralValue, SignedNumber, Expression)
	end
end
