# frozen_string_literal: true

module Plume
	class CollationExpression < Node
		token :collate_kw
		token :expression_tk
		token :sequence_tk

		attr :expression, Expression
		attr :sequence, Stringy

		def self.new(*, sequence:, **) = super
		def self.concrete(*, sequence_tk:, **) = super

		# Parser may pass either tokens or attributes, so
		# require none in `concrete` signature but ensure presence here.
		def after_initialize()
			if @expression.nil? && @expression_tk.nil?
				raise ArgumentError.new("missing either: :expression, :expression_tk")
			end
		end

		def expression = (@expression == LiteralNil) ? expression_tk_val : @expression
		def sequence = (@sequence == LiteralNil) ? sequence_tk_src.to_sym.upcase : @sequence
	end
end
