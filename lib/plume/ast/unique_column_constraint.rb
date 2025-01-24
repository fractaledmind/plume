# frozen_string_literal: true

module Plume
	class UniqueColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		optional_token :conflict_clause, inspect: true
	end
end
