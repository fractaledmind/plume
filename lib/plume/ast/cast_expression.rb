# frozen_string_literal: true

module Plume
	class CastExpression < Node
		token :cast_kw
		token :expression_lp
		token :as_kw
		token :expression_rp

		node :expression, Expression
		node :as, ColumnType

		def self.new(*, expression:, as:, **) = super
		def self.concrete(*, cast_kw:, expression_lp:, expression:, as_kw:, as:, expression_rp:, **) = super
	end
end
