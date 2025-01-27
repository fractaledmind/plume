# frozen_string_literal: true

module Plume
	class UniqueTableConstraint < TableConstraint
		prop :name, _Nilable(String)
		prop :columns, _Array(IndexedColumn)
		prop :on_conflict, _Nilable(ConflictClause)
	end
end
