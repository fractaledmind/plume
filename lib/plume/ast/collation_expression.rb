# frozen_string_literal: true

module Plume
	class CollationExpression < Node
		prop :expression, Expression
		prop :collation_name, Symbol
	end
end
