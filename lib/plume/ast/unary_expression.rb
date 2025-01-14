# frozen_string_literal: true

module Plume
	class UnaryExpression < Node
		prop :operator, _Union(:INVERT, :NEGATE, :IDENTITY, :NOT, :IS_NULL, :NOT_NULL)
		prop :operand, Expression
	end
end
