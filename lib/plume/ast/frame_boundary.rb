# frozen_string_literal: true

module Plume
	class FrameBoundary < Node
		prop :type, _Union(:PRECEDING, :FOLLOWING, :CURRENT_ROW)
		prop :value, _Union(Expression, :UNBOUNDED)
	end
end
