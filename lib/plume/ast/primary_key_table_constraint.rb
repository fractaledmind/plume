# frozen_string_literal: true

module Plume
	class PrimaryKeyTableConstraint < TableConstraint
		prop :name, _Nilable(String)
		prop :columns, _Array(IndexedColumn)
		prop :autoincrement, _Nilable(_Boolean)
		prop :on_conflict, _Nilable(ConflictClause)
	end
end
