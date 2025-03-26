# frozen_string_literal: true

module Plume
	class PrimaryKeyColumnConstraint < ColumnConstraint
		token :constraint_kw
		token :name_tk
		token :primary_key_kw
		token :direction_tk
		token :autoincrement_kw

		attr :name, Stringy
		attr :direction, Stringy
		attr :autoincrement, _Boolean
		node :conflict_clause, ConflictClause

		def self.new(*, **) = super
		def self.concrete(*, primary_key_kw:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
		def direction = (@direction == LiteralNil) ? direction_tk_val&.to_sym&.upcase : @direction
		def autoincrement = (@autoincrement == LiteralNil) ? !!@autoincrement_kw : @autoincrement
	end
end
