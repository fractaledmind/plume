# frozen_string_literal: true

module Plume
	class IndexedColumn < Node
		token :name_tk
		token :collate_kw
		token :collation_tk
		token :direction_tk

		attr :name, Stringy
		attr :collation, Stringy
		attr :direction, Stringy

		def self.new(*, name:, **) = super
		def self.concrete(*, name_tk:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
		def collation = (@collation == LiteralNil) ? collation_tk_val&.to_sym&.upcase : @collation
		def direction = (@direction == LiteralNil) ? direction_tk_val&.to_sym&.upcase : @direction
	end
end
