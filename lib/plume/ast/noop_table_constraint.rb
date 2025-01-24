# frozen_string_literal: true

module Plume
	class NoOpTableConstraint < TableConstraint
		optional_token :name, inspect: true
	end
end
