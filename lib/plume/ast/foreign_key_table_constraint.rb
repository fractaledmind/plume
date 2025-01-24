# frozen_string_literal: true

module Plume
	class ForeignKeyTableConstraint < TableConstraint
		token :name, required: false, inspect: true
		prop :columns, _Array(IndexedColumn)
		prop :foreign_key_clause, ForeignKeyClause
	end
end
