# frozen_string_literal: true

module Plume
	class ParentheticalExpression < Node
		token :value_lp
		token :value_tk
		token :value_rp

		attr :value, _Union(Expression, _Array(Expression))

		def self.new(*, value:, **) = super
		def self.concrete(*, **) = super

		# Parser may pass either tokens or attributes, so
		# require none in `concrete` signature but ensure presence here.
		def after_initialize()
			if @value == LiteralNil && @value_tk == LiteralNil
				raise ArgumentError.new("missing either: :value, :value_tk")
			end
		end

		def value
			v = (@value == LiteralNil) ? value_tk_val : @value
			case v
			when LiteralNil then nil
			when LiteralFalse then false
			when LiteralExpression then v.value
			else v
			end
		end
	end
end
