# frozen_string_literal: true

module Plume
	class PrimaryKeyTableConstraint < TableConstraint
		token :constraint_kw
		token :name_tk
		token :primary_key_kw
		token :primary_key_lp
		token :autoincrement_kw
		token :primary_key_rp

		attr :name, Stringy
		attr :autoincrement, _Boolean
		nodes :columns, IndexedColumn
		node :conflict_clause, ConflictClause

		def self.new(*, columns:, **) = super
		def self.concrete(*, primary_key_kw:, columns:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
		def autoincrement = (@autoincrement == LiteralNil) ? !!@autoincrement_kw : @autoincrement
	end
end
