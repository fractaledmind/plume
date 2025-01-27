# frozen_string_literal: true

module Plume
	class NoOpColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
	end
end
