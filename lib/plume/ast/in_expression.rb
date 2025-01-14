# frozen_string_literal: true

module Plume
	class InExpression < Node
		prop :member, Expression
		prop :collection, _Union(
			SelectStatement,
			TableReference,
			FunctionReference,
			_Array(Expression),
		)
	end
end
