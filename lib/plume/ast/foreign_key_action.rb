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

		required_token :on_kw
		required_token :trigger_kw,
			reader: :trigger,
			default: -> { trigger_kw_src.to_sym.upcase }
		required_token :action_kw,
			reader: :action,
			default: -> { TOKEN_TO_ACTION[action_kw_tok] }
	end
end
