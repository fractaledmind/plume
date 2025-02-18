# frozen_string_literal: true

module Plume
	class JoinUsingConstraint < Node
		prop :columns, _Array(String)
	end
end
