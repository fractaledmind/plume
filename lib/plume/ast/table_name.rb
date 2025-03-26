# frozen_string_literal: true

module Plume
	class TableName < Node
		token :schema_tk
		token :dot_tk
		token :table_tk

		attr :schema, Stringy
		attr :table, Stringy

		def self.new(*, table:, **) = super
		def self.concrete(*, table_tk:, **) = super

		def schema = (@schema == LiteralNil) ? schema_tk_val : @schema
		def table = (@table == LiteralNil) ? table_tk_val : @table

		alias_method :name, :table
	end
end
