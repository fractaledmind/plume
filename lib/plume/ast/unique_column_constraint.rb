# frozen_string_literal: true

module Plume
	class UniqueColumnConstraint < ColumnConstraint
		token :constraint_kw
		token :name_tk
		token :unique_kw

		attr :name, Stringy
		node :conflict_clause, ConflictClause

		def self.new(*, **) = super
		def self.concrete(*, unique_kw:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
