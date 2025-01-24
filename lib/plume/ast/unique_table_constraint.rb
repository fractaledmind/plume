# frozen_string_literal: true

module Plume
	class UniqueTableConstraint < TableConstraint
		required_nodes :columns, IndexedColumn

		optional_token :name, inspect: true
		optional_token :conflict_clause, inspect: true
	end
end
