# frozen_string_literal: true

module Plume
	class NotNullColumnConstraint < ColumnConstraint
		token :constraint_kw
		token :name_tk
		token :not_null_kw

		attr :name, Stringy
		node :conflict_clause, ConflictClause

		def self.new(*, **) = super
		def self.concrete(*, not_null_kw:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
