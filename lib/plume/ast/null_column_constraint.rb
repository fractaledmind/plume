# frozen_string_literal: true

module Plume
	class NullColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :conflict_clause, _Nilable(ConflictClause)
	end
end
