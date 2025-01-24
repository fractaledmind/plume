# frozen_string_literal: true

module Plume
	class UniqueTableConstraint < TableConstraint
		required_nodes :columns, IndexedColumn

		optional_node :conflict_clause, ConflictClause

		optional_token :name, inspect: true
	end
end
