# frozen_string_literal: true

module Plume
	class CastExpression < Node
		prop :expression, Expression
		prop :as, Type
	end
end
