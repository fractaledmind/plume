# frozen_string_literal: true

module Plume
	class CollationExpression < Node
		token :expression_tk
		token :sequence_tk

		attr :expression, Expression
		attr :sequence, Stringy


		def self.new(*, expression:, sequence:, **) = super
		def self.concrete(*, expression_tk:, sequence_tk:, **) = super

		def expression = @expression || expression_tk_val
		def sequence = @sequence || sequence_tk_src.to_sym.upcase
	end
end
