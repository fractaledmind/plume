# frozen_string_literal: true

module Plume
	LiteralNil = Object.new
	def LiteralNil.inspect = "<LiteralNil>"
	LiteralNil.freeze
end
