# frozen_string_literal: true

module Plume
	class CheckTableConstraint < TableConstraint
		required_node :expression, Expression

		optional_token :name, inspect: true
	end
end
