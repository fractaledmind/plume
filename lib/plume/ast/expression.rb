# frozen_string_literal: true

module Plume
	Expression = _Union(
		LiteralValue,
		Token,
		ColumnName,
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
				SignedExpression,
				LiteralExpression,
			)
		},
	)
end
