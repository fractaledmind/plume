# frozen_string_literal: true

module Plume
	class NullColumnConstraint < ColumnConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :null_kw
		optional_node :conflict_clause, ConflictClause
	end
end
