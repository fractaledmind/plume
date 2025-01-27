# frozen_string_literal: true

module Plume
	class NullColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :on_conflict, _Nilable(ConflictClause)
	end
end
