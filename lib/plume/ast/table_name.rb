# frozen_string_literal: true

module Plume
	class TableName < Node
		token :schema_tk
		token :dot_tk
		token :table_tk
		token :as_kw
		token :alias_tk

		attr :schema, Stringy
		attr :table, Stringy
		attr :alias, Stringy

		def self.new(*, table:, **) = super
		def self.concrete(*, table_tk:, **) = super

		def schema = (@schema == LiteralNil) ? schema_tk_val : @schema
		def table = (@table == LiteralNil) ? table_tk_val : @table
		def alias = (@alias == LiteralNil) ? alias_tk_val : @alias

		alias_method :name, :table
	end
end
