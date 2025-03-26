# frozen_string_literal: true

module Plume
	class MatchClause < Node
		token :match_kw
		token :type_tk

		attr :type, Stringy

		def self.new(*, type:, **) = super
		def self.concrete(*, match_kw:, type_tk:, **) = super

		def type = (@type == LiteralNil) ? type_tk_src.to_sym.upcase : @type
	end
end
