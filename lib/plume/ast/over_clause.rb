# frozen_string_literal: true

module Plume
	class OverClause < Node
		prop :window_name, _Nilable(String)
		prop :base_window_name, _Nilable(String)
		prop :partition_by, _Nilable(_Array(Expression))
		prop :order_by, _Nilable(_Array(OrderingTerm))
		prop :frame, _Nilable(FrameSpec)
	end
end
