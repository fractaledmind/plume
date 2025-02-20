# frozen_string_literal: true

module Plume
	class ForeignKeyTableConstraint < TableConstraint
		prop :name, _Nilable(String)
		prop :columns, _Array(IndexedColumn)
		prop :foreign_key_clause, ForeignKeyClause
	end
end
