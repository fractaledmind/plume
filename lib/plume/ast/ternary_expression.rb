# frozen_string_literal: true

module Plume
	class TernaryExpression < Node
		prop :operator, _Union(:BETWEEN, :NOT_BETWEEN)
		prop :left, Expression
		prop :middle, Expression
		prop :right, Expression
	end
end
