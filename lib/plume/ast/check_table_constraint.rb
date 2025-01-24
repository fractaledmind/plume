# frozen_string_literal: true

module Plume
	class CheckTableConstraint < TableConstraint
		token :name, required: false, inspect: true
		prop :expression, Expression
	end
end
