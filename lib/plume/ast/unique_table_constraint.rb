# frozen_string_literal: true

module Plume
	class UniqueTableConstraint < TableConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		optional_token :unique_kw
		optional_token :unique_lp
		required_nodes :columns, IndexedColumn
		optional_token :unique_rp
		optional_node :conflict_clause, ConflictClause
	end
end
