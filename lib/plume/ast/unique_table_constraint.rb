# frozen_string_literal: true

module Plume
	class UniqueTableConstraint < TableConstraint
		token :name, required: false, inspect: true
		node :columns, IndexedColumn, required: true, collection: true
		node :conflict_clause, ConflictClause, required: false
	end
end
