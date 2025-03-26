# frozen_string_literal: true

module Plume
	class DefaultColumnConstraint < ColumnConstraint
		token :constraint_kw
		token :name_tk
		token :default_kw
		token :default_lp
		token :default_rp
		token :value_tk

		attr :name, Stringy
		attr :value, Expression

		def self.new(*, **) = super
		def self.concrete(*, default_kw:, **) = super

		# Parser may pass either tokens or attributes, so
		# require none in `concrete` signature but ensure presence here.
		def after_initialize()
			if @value.nil? && @value_tk.nil?
				raise ArgumentError.new("missing either: :value, :value_tk")
			end
		end

		def name = (@name == LiteralNil) ? name_tk_val : @name
		def value = (@value == LiteralNil) ? value_tk_val : @value
	end
end
