# frozen_string_literal: true

module Plume
	class CheckColumnConstraint < ColumnConstraint
		token :constraint_kw
		token :name_tk
		token :check_kw
		token :check_lp
		token :check_rp

		attr :name, Stringy
		node :expression, Expression
		node :conflict_clause, ConflictClause

		def self.new(*, expression:, **) = super
		def self.concrete(*, check_kw:, check_lp:, expression:, check_rp:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
