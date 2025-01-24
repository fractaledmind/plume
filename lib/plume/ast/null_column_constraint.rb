# frozen_string_literal: true

module Plume
	class NullColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		prop :conflict_clause, _Nilable(ConflictClause)
	end
end
