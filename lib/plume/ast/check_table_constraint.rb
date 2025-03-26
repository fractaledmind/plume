# frozen_string_literal: true

module Plume
	class CheckTableConstraint < TableConstraint
		token :constraint_kw
		token :name_tk
		token :check_kw
		token :check_lp
		token :check_rp

		attr :name, Stringy
		node :expression, Expression

		def self.new(*, expression:, **) = super
		def self.concrete(*, expression:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
