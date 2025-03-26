# frozen_string_literal: true

module Plume
	class NoOpTableConstraint < TableConstraint
		token :constraint_kw
		token :name_tk

		attr :name, Stringy

		def self.new(*, **) = super
		def self.concrete(*, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
