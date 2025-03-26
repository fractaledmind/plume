# frozen_string_literal: true

module Plume
	class ForeignKeyAction < Node
		TOKEN_TO_ACTION = {
			:CASCADE                => :CASCADE,
			:RESTRICT               => :RESTRICT,
			[:SET, :NULL].freeze    => :SET_NULL,
			[:SET, :DEFAULT].freeze => :SET_DEFAULT,
			[:NO, :ACTION].freeze   => :NO_ACTION,
		}.freeze

		token :on_kw
		token :trigger_kw
		token :action_kw

		attr :trigger, Stringy
		attr :action, _Union(TOKEN_TO_ACTION.values)

		def self.new(*, trigger:, action:, **) = super
		def self.concrete(*, on_kw:, trigger_kw:, action_kw:, **) = super

		def trigger = (@trigger == LiteralNil) ? trigger_kw_src.to_sym.upcase : @trigger
		def action = (@action == LiteralNil) ? TOKEN_TO_ACTION[action_kw_tok] : @action
	end
end
