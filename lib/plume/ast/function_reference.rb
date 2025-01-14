# frozen_string_literal: true

module Plume
	class FunctionReference < Node
		prop :schema_name, _Nilable(String)
		prop :function_name, _Union(String, Symbol)
		prop :arguments, _Union(FunctionArguments, StarFunctionArgument, EmptyFunctionArgument)
		prop :filter_clause, _Nilable(Expression)
		prop :over_clause, _Nilable(OverClause)
	end
end
