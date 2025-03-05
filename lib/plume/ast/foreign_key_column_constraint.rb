# frozen_string_literal: true

module Plume
	class ForeignKeyColumnConstraint < ColumnConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_node :foreign_key_clause, ForeignKeyClause
	end
end
