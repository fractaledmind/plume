# frozen_string_literal: true

module Plume
	class UniqueTableConstraint < TableConstraint
		token :constraint_kw
		token :name_tk
		token :unique_kw
		token :unique_lp
		token :unique_rp

		attr :name, Stringy
		nodes :columns, IndexedColumn
		node :conflict_clause, ConflictClause

		def self.new(*, columns:, **) = super
		def self.concrete(*, columns:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
