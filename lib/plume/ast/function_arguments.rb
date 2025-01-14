# frozen_string_literal: true

module Plume
	class FunctionArguments < Node
		prop :distinct, _Nilable(_Boolean)
		prop :expressions, _Array(Expression)
		prop :order_by, _Nilable(_Array(OrderingTerm))
	end
end
