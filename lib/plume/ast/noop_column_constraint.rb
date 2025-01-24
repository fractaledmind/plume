# frozen_string_literal: true

module Plume
	class NoOpColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
	end
end
