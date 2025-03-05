# frozen_string_literal: true

module Plume
	class PrimaryKeyTableConstraint < TableConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :primary_key_kw
		optional_token :primary_key_lp
		required_nodes :columns, IndexedColumn
		optional_token :autoincrement_kw,
			reader: :autoincrement,
			default: -> { !!@autoincrement_kw }
		optional_token :primary_key_rp
		optional_node :conflict_clause, ConflictClause
	end
end
