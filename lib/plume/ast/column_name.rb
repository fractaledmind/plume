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

		def schema = @schema || schema_tk_val
		def table = @table || table_tk_val
		def column = @column || column_tk_val
	end
end
