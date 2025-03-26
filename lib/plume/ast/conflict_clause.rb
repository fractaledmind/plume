# frozen_string_literal: true

module Plume
	class ConflictClause < Node
		RAISE_KWS = Set[:ROLLBACK, :ABORT, :FAIL].freeze
		RESOLVE_KWS = Set[:IGNORE, :REPLACE].freeze
		RESOLUTIONS = (RAISE_KWS + RESOLVE_KWS).freeze

		token :on_conflict_kw
		token :resolution_kw

		attr :resolution, RESOLUTIONS

		def self.new(*, resolution:, **) = super
		def self.concrete(*, on_conflict_kw:, resolution_kw:, **) = super

		def resolution = (@resolution == LiteralNil) ? resolution_kw_src.to_sym.upcase : @resolution

		def raise? = RAISE_KWS.include?(resolution)
		def resolve? = RESOLVE_KWS.include?(resolution)
	end
end
