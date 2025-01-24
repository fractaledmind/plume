# frozen_string_literal: true

module Plume
	class PrimaryKeyTableConstraint < TableConstraint
		token :name, required: false, inspect: true
		prop :columns, _Array(IndexedColumn)
		prop :autoincrement, _Nilable(_Boolean)
		prop :conflict_clause, _Nilable(ConflictClause)
	end
end
