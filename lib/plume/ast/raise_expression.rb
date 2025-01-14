# frozen_string_literal: true

module Plume
	class RaiseExpression < Node
		prop :type, _Union(:IGNORE, :ROLLBACK, :ABORT, :FAIL)
		prop :message, _Nilable(String)
	end
end
