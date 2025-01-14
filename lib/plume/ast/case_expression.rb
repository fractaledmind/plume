# frozen_string_literal: true

module Plume
	class CaseExpression < Node
		prop :predicate, _Nilable(Expression)
		prop :conditions, _Array(CaseCondition)
		prop :else_clause, _Nilable(Expression)
	end
end
