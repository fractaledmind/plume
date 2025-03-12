# frozen_string_literal: true

module Plume
	class ColumnName < Node
		token :schema_tk # maybe
		token :dot1 # maybe
		token :table_tk # maybe
		token :dot2 # maybe
		token :column_tk # required

		attr :schema, Stringy # maybe
		attr :table, Stringy # maybe
		attr :column, Stringy # required

		def self.new(*, column:, **) = super
		def self.concrete(*, column_tk:, **) = super

		def schema = (@schema == LiteralNil) ? schema_tk_val : @schema
		def table = (@table == LiteralNil) ? table_tk_val : @table
		def column = (@column == LiteralNil) ? column_tk_val : @column
	end
end
