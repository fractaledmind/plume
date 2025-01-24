# frozen_string_literal: true

module Plume
	class PrimaryKeyColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		prop :direction, _Nilable(Direction)
		prop :conflict_clause, _Nilable(ConflictClause)
		prop :autoincrement, _Nilable(_Boolean)
	end
end
