# frozen_string_literal: true

module Plume
	class FrameBoundary < Node
		Type = _Union(
			:PRECEDING, "PRECEDING", :preceding, "preceding",
			:FOLLOWING, "FOLLOWING", :following, "following",
			:CURRENT_ROW, "CURRENT_ROW", :current_row, "current_row",
		)
		Value = _Union(
			:UNBOUNDED, "UNBOUNDED", :unbounded, "unbounded",
			Expression,
		)

		token :type_tk
		token :value_tk

		attr :type, Type
		attr :value, Value

		def self.new(*, type:, **) = super
		def self.concrete(*, type_tk:, **) = super

		# Parser may pass either tokens or attributes, so
		# require none in `concrete` signature but ensure presence here.
		def after_initialize()
			if @value.nil? && @value_tk.nil?
				raise ArgumentError.new("missing either: :value, :value_tk")
			end
		end

		def type = (@type == LiteralNil) ? type_tk_src.gsub(" ", "_").to_sym.upcase : @type
		def value = (@value == LiteralNil) ? value_tk_src&.to_sym&.upcase : @value
	end
end
