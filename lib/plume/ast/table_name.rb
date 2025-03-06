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

		def schema = @schema || schema_tk_val
		def table = @table || table_tk_val

		alias_method :name, :table
	end
end
