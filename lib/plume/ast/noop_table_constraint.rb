# frozen_string_literal: true

module Plume
	class NoOpTableConstraint < TableConstraint
		token :name, required: false, inspect: true
	end
end
