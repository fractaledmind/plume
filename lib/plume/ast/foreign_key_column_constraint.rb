# frozen_string_literal: true

module Plume
	class ForeignKeyColumnConstraint < ColumnConstraint
		token :constraint_kw
		token :name_tk

		attr :name, Stringy
		node :foreign_key_clause, ForeignKeyClause

		def self.new(*, foreign_key_clause:, **) = super
		def self.concrete(*, foreign_key_clause:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
