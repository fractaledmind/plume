# frozen_string_literal: true

module Plume
	class MatchClause < Node
		required_token :match_kw
		required_token :type_tk,
			reader: :type,
			default: -> { type_tk_src.to_sym.upcase }
	end
end
