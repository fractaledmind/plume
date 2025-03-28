# frozen_string_literal: true

module Plume
	class StarResultColumn < Node
		token :table_tk
		token :dot_tk
		token :star_tk

		attr :table, Stringy

		def self.new(*, **) = super
		def self.concrete(*, star_tk:, **) = super

		def table = (@table == LiteralNil) ? table_tk_val : @table
	end
end
