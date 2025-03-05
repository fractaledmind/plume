# frozen_string_literal: true

module Plume
	class ForeignKeyTableConstraint < TableConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :foreign_key_kw
		optional_token :foreign_key_lp
		required_nodes :columns, IndexedColumn
		optional_token :foreign_key_rp
		required_node :foreign_key_clause, ForeignKeyClause
	end
end
