# frozen_string_literal: true

module Plume
	class UnaryExpression < Node
		TOKEN_TO_OPERATOR = {
			:BITNOT => :INVERT,
			:PLUS => :IDENTITY,
			:MINUS => :NEGATE,
			:NOT => :NOT,
			:ISNULL => :IS_NULL,
			:NOTNULL => :NOT_NULL
		}.freeze
		Operator = _Union(*TOKEN_TO_OPERATOR.values)

		token :operator_tk         # required
		token :operand_tk          # required

		attr :operator, Operator   # required
		attr :operand,  Expression # required

		def self.new(*, operator:, operand:, **) = super
		def self.concrete(*, operator_tk:, **) = super

		# Parser may pass either tokens or attributes, so
		# require none in `concrete` signature but ensure presence here.
		def after_initialize()
			if @operand.nil? && @operand_tk.nil?
				raise ArgumentError.new("missing either: :operand, :operand_tk")
			end
		end

		def operator = (@operator == LiteralNil) ? TOKEN_TO_OPERATOR[operator_tk_tok] : @operator
		def operand = (@operand == LiteralNil) ? operand_tk_val : @operand
	end
end
