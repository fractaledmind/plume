# frozen_string_literal: true

module Plume
	class NoOpTableConstraint < TableConstraint
		optional_token :constraint_kw
		optional_token :name_tk,
			reader: :name,
			default: -> { name_tk_val }
	end
end
