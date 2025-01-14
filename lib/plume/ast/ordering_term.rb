# frozen_string_literal: true

module Plume
	class OrderingTerm < Node
		prop :expression, Expression
		prop :collation, _Nilable(String)
		prop :direction, _Nilable(Direction)
		prop :nulls, _Nilable(_Union(:FIRST, :LAST))
	end
end
