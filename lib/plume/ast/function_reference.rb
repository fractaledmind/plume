# frozen_string_literal: true

module Plume
	class FunctionReference < Node
		token :schema_tk
		token :dot_tk
		token :function_tk
		token :arguments_lp
		token :arguments_rp

		attr :schema, Stringy
		attr :function, Stringy
		node :arguments, _Union(FunctionArguments, StarFunctionArgument, EmptyFunctionArgument)
		node :filter_clause, Expression
		node :over_clause, OverClause

		def self.new(*, function:, **) = super
		def self.concrete(*, function_tk:, **) = super

		def schema = (@schema == LiteralNil) ? schema_tk_val : @schema
		def function = (@function == LiteralNil) ? function_tk_val : @function

		alias_method :name, :function
	end
end
