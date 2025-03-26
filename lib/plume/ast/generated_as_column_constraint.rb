# frozen_string_literal: true

module Plume
	class GeneratedAsColumnConstraint < ColumnConstraint
		Type = _Union(:STORED, :VIRTUAL)

		token :constraint_kw
		token :name_tk
		token :as_kw
		token :as_lp
		token :as_rp
		token :type_tk

		attr :name, Stringy
		attr :type, Type
		node :expression, Expression

		def self.new(*, expression:, **) = super
		def self.concrete(*, as_kw:, as_lp:, expression:, as_rp:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
		def type = (@type == LiteralNil) ? type_tk_val&.to_sym&.upcase : @type
	end
end
