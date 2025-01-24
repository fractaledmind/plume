# frozen_string_literal: true

module Plume
	class PrimaryKeyTableConstraint < TableConstraint
		required_nodes :columns, IndexedColumn

		optional_node :conflict_clause, ConflictClause

		optional_token :name, inspect: true
		optional_token :autoincrement_kw

		inspectable def autoincrement = !!@autoincrement_kw
	end
end
