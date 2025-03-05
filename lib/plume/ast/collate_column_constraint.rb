# frozen_string_literal: true

module Plume
	class CollateColumnConstraint < ColumnConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		required_token :collate_kw
		required_token :collation_tk,
			reader: :collation,
			default: -> { collation_tk_val&.to_sym&.upcase }
	end
end
