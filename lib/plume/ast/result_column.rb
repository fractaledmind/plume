# frozen_string_literal: true

module Plume
	class ResultColumn < Node
		token :as_kw
		token :alias_tk

		node :result, Expression
		attr :alias, Stringy

		def self.new(*, result:, **) = super
		def self.concrete(*, result:, **) = super

		def alias = (@alias == LiteralNil) ? alias_tk_val : @alias
	end
end
