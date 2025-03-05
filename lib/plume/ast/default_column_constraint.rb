# frozen_string_literal: true

module Plume
	class DefaultColumnConstraint < ColumnConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :default_kw
		optional_token :default_lp
		optional_token :default_rp
		required_token :value_tk,
			reader: :value,
			default: -> { value_tk_val }
	end
end
