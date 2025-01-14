# frozen_string_literal: true

module Plume
	class BinaryExpression < Node
		prop :operator, _Union(
			:ABOVE,
			:ADD,
			:ALL,
			:ANY,
			:ATLEAST,
			:ATMOST,
			:BELOW,
			:BIT_AND,
			:BIT_LSHIFT,
			:BIT_OR,
			:BIT_RSHIFT,
			:CONCAT,
			:DIVIDE,
			:EQUALS,
			:EXTRACT,
			:GLOB,
			:IS,
			:IS_NOT,
			:MATCH,
			:MODULO,
			:MULTIPLY,
			:NOT_EQUALS,
			:NOT_GLOB,
			:NOT_MATCH,
			:NOT_REGEXP,
			:REGEXP,
			:RETRIEVE,
			:SUB,
		)

		prop :left, Expression
		prop :right, Expression
	end
end
