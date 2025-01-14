# frozen_string_literal: true

module Plume
	class LikeExpression < Node
		prop :left, Expression
		prop :right, Expression
		prop :escape, _Nilable(Expression)
	end
end
