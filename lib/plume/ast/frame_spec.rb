# frozen_string_literal: true

module Plume
	class FrameSpec < Node
		prop :type, _Union(:RANGE, :ROWS, :GROUPS)
		prop :starting_boundary, _Any
		prop :ending_boundary, _Nilable(_Any)
		prop :exclude, _Nilable(_Union(:NO_OTHERS, :CURRENT_ROW, :GROUP, :TIES))
	end
end
