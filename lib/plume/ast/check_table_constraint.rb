# frozen_string_literal: true

module Plume
	class CheckTableConstraint < TableConstraint
		prop :name, _Nilable(String)
		prop :expression, Expression
	end
end
