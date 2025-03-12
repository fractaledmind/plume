# frozen_string_literal: true

module Plume
	class LiteralExpression < Node
		token :value_tk          # required

		attr :value, _Void # required

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
			else v
			end
		end
	end
end
