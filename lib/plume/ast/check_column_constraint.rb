# frozen_string_literal: true

module Plume
	class CheckColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		prop :expression, Expression
	end
end
