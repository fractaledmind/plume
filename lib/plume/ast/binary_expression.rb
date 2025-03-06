# frozen_string_literal: true

module Plume
	class BinaryExpression < Node
		TOKEN_TO_OPERATOR = {
			:AND                                 => :ALL,
			:OR                                  => :ANY,
			:CONCAT                              => :CONCAT,
			:PTR1                                => :EXTRACT,
			:PTR2                                => :RETRIEVE,
			:STAR                                => :MULTIPLY,
			:SLASH                               => :DIVIDE,
			:REM                                 => :MODULO,
			:PLUS                                => :ADD,
			:MINUS                               => :SUB,
			:BITAND                              => :BIT_AND,
			:BITOR                               => :BIT_OR,
			:LSHIFT                              => :BIT_LSHIFT,
			:RSHIFT                              => :BIT_RSHIFT,
			:LT                                  => :BELOW,
			:GT                                  => :ABOVE,
			:LE                                  => :ATMOST,
			:GE                                  => :ATLEAST,
			:EQ                                  => :EQUALS,
			:NE                                  => :NOT_EQUALS,
			:IS                                  => :IS,
			:GLOB                                => :GLOB,
			:REGEXP                              => :REGEXP,
			:MATCH                               => :MATCH,
			[:IS, :NOT, :DISTINCT, :FROM].freeze => :IS,
			[:IS, :DISTINCT, :FROM].freeze       => :IS_NOT,
			[:IS, :NOT].freeze                   => :IS_NOT,
			[:IS].freeze                         => :IS,
			[:GLOB].freeze                       => :GLOB,
			[:REGEXP].freeze                     => :REGEXP,
			[:MATCH].freeze                      => :MATCH,
			[:NOT, :GLOB].freeze                 => :NOT_GLOB,
			[:NOT, :REGEXP].freeze               => :NOT_REGEXP,
			[:NOT, :MATCH].freeze                => :NOT_MATCH,
		}.freeze
		Operator = _Union(*TOKEN_TO_OPERATOR.values)

		token :operator_tk         # required
		token :left_tk             # required
		token :right_tk            # required

		attr :operator, Operator   # required
		attr :left,     Expression # required
		attr :right,    Expression # required

		def self.new(*, operator:, left:, right:, **) = super
		def self.concrete(*, operator_tk:, **) = super

		# Parser may pass either tokens or attributes, so
		# require none in `concrete` signature but ensure presence here.
		def after_initialize()
			if @left.nil? && @left_tk.nil?
				raise ArgumentError.new("missing either: :left, :left_tk")
			elsif @right.nil? && @right_tk.nil?
				raise ArgumentError.new("missing either: :right, :right_tk")
			end
		end

		def operator = @operator || TOKEN_TO_OPERATOR[operator_tk_tok]
		def left = @left || left_tk_val
		def right = @right || right_tk_val
	end
end
