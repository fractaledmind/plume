# frozen_string_literal: true

module Plume
	class FrameSpec < Node
		Type = _Union(
			:RANGE, "RANGE", :range, "range",
			:ROWS, "ROWS", :rows, "rows",
			:GROUPS, "GROUPS", :groups, "groups",
		)
		Exclude = _Union(
			:NO_OTHERS, "NO_OTHERS", :no_others, "no_others",
			:CURRENT_ROW, "CURRENT_ROW", :current_row, "current_row",
			:GROUP, "GROUP", :group, "group",
			:TIES, "TIES", :ties, "ties",
		)

		token :type_tk
		token :between_kw
		token :and_kw
		token :exclude_kw
		token :exclude_tk

		attr :type, Type
		attr :exclude, Exclude
		node :starting_boundary, FrameBoundary
		node :ending_boundary, FrameBoundary

		def self.new(*, type:, starting_boundary:, **) = super
		def self.concrete(*, type_tk:, starting_boundary:, **) = super

		def type = (@type == LiteralNil) ? type_tk_src.to_sym.upcase : @type
		def exclude = (@exclude == LiteralNil) ? exclude_tk_src.gsub(" ", "_").to_sym.upcase : @exclude
	end
end
