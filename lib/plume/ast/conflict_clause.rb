# frozen_string_literal: true

module Plume
	class ConflictClause < Node
		required_token :on_conflict_kw
		required_token :resolution_kw,
			reader: :resolution,
			default: -> { resolution_kw_src.to_sym.upcase }

		RAISE_KWS = Set[:ROLLBACK, :ABORT, :FAIL].freeze
		RESOLVE_KWS = Set[:IGNORE, :REPLACE].freeze

		def raise? = RAISE_KWS.include?(resolution)
		def resolve? = RESOLVE_KWS.include?(resolution)
	end
end
