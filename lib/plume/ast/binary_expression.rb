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
		Operator = _Union(TOKEN_TO_OPERATOR.values)

		required_token :operator_tk,
			reader: :operator,
			type: Operator,
			default: -> { TOKEN_TO_OPERATOR[operator_tk_tok] }
		required_token :left_tk,
			reader: :left,
			type: Expression,
			default: -> { left_tk_val }
		required_token :right_tk,
			reader: :right,
			type: Expression,
			default: -> { right_tk_val }
	end
end
