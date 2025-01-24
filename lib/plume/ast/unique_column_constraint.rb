# frozen_string_literal: true

module Plume
	class UniqueColumnConstraint < ColumnConstraint
		optional_node :conflict_clause, ConflictClause

		optional_token :name, inspect: true
	end
end
