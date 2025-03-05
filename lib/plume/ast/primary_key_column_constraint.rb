# frozen_string_literal: true

module Plume
	class PrimaryKeyColumnConstraint < ColumnConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :primary_key_kw
		optional_token :direction_tk,
			reader: :direction,
			default: -> { direction_tk_val&.to_sym&.upcase }
		optional_node  :conflict_clause, ConflictClause
		optional_token :autoincrement_kw,
			reader: :autoincrement,
			default: -> { !!@autoincrement_kw }
	end
end
