# frozen_string_literal: true

module Plume
	class PrimaryKeyColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :direction, _Nilable(Direction)
		prop :on_conflict, _Nilable(ConflictClause)
		prop :autoincrement, _Nilable(_Boolean)
	end
end
