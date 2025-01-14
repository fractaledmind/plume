# frozen_string_literal: true

module Plume
	class CaseCondition < Node
		prop :predicate, Expression
		prop :consequence, Expression
	end
end
