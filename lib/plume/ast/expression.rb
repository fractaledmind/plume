# frozen_string_literal: true

module Plume
	Expression = _Union(
		LiteralValue,
		ColumnReference,
		_Deferred {
			_Union(
				UnaryExpression,
				BinaryExpression,
				CastExpression,
				TernaryExpression,
				LikeExpression,
				InExpression,
				NotInExpression,
				CollationExpression,
				RaiseExpression,
				FunctionReference,
			)
		},
	)
end
