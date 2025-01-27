# frozen_string_literal: true

module Plume
	class NoOpTableConstraint < TableConstraint
		prop :name, _Nilable(String)
	end
end
