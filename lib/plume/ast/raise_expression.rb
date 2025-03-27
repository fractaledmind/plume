# frozen_string_literal: true

module Plume
	class RaiseExpression < Node
		Type = _Union(:IGNORE, :ROLLBACK, :ABORT, :FAIL)

		token :raise_kw              # required
		token :raise_lp              # required
		token :type_kw               # required
		token :comma                 # maybe
		token :error_message_tk      # maybe
		token :raise_rp              # required

		attr :type,          Type    # required
		attr :error_message, Expression # maybe

		def self.new(*, type:, **) = super
		def self.concrete(*, raise_kw:, raise_lp:, type_kw:, raise_rp:, **) = super

		def type = (@type == LiteralNil) ? type_kw_src.to_sym.upcase : @type
		def error_message = (@error_message == LiteralNil) ? error_message_tk_val : @error_message
	end
end
