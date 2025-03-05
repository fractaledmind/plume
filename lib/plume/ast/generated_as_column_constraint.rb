# frozen_string_literal: true

module Plume
	class GeneratedAsColumnConstraint < ColumnConstraint
		Type = _Union(:STORED, :VIRTUAL)

		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :as_kw
		required_token :as_lp
		required_node :expression, Expression
		required_token :as_rp
		optional_token :type_tk,
			reader: :type,
			default: -> { type_tk_val&.to_sym&.upcase }
	end
end
