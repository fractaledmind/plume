# frozen_string_literal: true

module Plume
	class IndexedColumn < Node
		required_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
		optional_token :collate_kw
		optional_token :collation_tk,
			reader: :collation,
			default: -> { collation_tk_val&.to_sym&.upcase }
		optional_token :direction_tk,
			reader: :direction,
			default: -> { direction_tk_val&.to_sym&.upcase }
	end
end
