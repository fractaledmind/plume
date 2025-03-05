# frozen_string_literal: true

module Plume
	class CheckColumnConstraint < ColumnConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :check_kw
		required_token :check_lp
		required_node :expression, Expression
		required_token :check_rp
		optional_node :conflict_clause, ConflictClause
	end
end
