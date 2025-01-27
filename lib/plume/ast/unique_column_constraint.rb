# frozen_string_literal: true

module Plume
	class UniqueColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :on_conflict, _Nilable(ConflictClause)
	end
end
