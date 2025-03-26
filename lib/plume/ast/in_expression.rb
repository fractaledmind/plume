# frozen_string_literal: true

module Plume
	class InExpression < Node
		token :member_tk          # required
		token :collection_lp
		token :collection_rp

		attr :member, Expression # required
		attr :collection, _Union(
			SelectStatement,
			TableName,
			FunctionReference,
			_Array(Expression),
		)






	end
end
