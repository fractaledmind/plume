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
		attr :error_message, Stringy # maybe

		def self.new(*, type:, **) = super
		def self.concrete(*, raise_kw:, raise_lp:, type_kw:, raise_rp:, **) = super

		def type = @type || type_kw_src.to_sym.upcase
		def error_message = @error_message || error_message_tk_val
	end
end
