# frozen_string_literal: true

module Plume
	class ColumnDefinition < Node
		token :name_tk

		attr :name, Stringy
		node :type, ColumnType
		nodes :constraints, ColumnConstraint

		def self.new(*, name:, **) = super
		def self.concrete(*, name_tk:, **) = super

		def name = (@name == LiteralNil) ? name_tk_val : @name
	end
end
