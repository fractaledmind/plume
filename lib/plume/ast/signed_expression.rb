# frozen_string_literal: true

module Plume
	class SignedExpression < Node
		prop :sign, _Union(:PLUS, :MINUS)
		prop :expression, Expression
	end
end
