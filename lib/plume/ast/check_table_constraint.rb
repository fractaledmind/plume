# frozen_string_literal: true

module Plume
	class CheckTableConstraint < TableConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		optional_token :check_kw
		optional_token :check_lp
		required_node :expression, Expression
		optional_token :check_rp
	end
end
