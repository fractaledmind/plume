# frozen_string_literal: true

module Plume
	class OverClause < Node
		token :over_kw
		token :window_lp
		token :base_window_name_tk
		token :partition_by_kw
		token :order_by_kw
		token :window_rp
		token :window_name_tk

		nodes :partitions, Expression
		nodes :orderings, OrderingTerm
		node :frame, FrameSpec
		attr :window_name, Stringy
		attr :base_window_name, Stringy

		def self.new(*, **) = super
		def self.concrete(*, over_kw:, **) = super

		def window_name = (@window_name == LiteralNil) ? window_name_tk_val : @window_name
		def base_window_name = (@base_window_name == LiteralNil) ? base_window_name_tk_val : @base_window_name
	end
end
