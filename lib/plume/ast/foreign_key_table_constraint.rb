# frozen_string_literal: true

module Plume
	class ForeignKeyTableConstraint < TableConstraint
		token :constraint_kw
		token :name_tk
		token :foreign_key_kw
		token :foreign_key_lp
		token :foreign_key_rp

		attr :name, Stringy
		nodes :columns, IndexedColumn
		node :foreign_key_clause, ForeignKeyClause

		def self.new(*, columns:, foreign_key_clause:, **) = super
		def self.concrete(*, foreign_key_kw:, columns:, foreign_key_clause:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
