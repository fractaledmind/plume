# frozen_string_literal: true

module Plume
	LiteralFalse = Object.new
	def LiteralFalse.inspect = "<LiteralFalse>"
	LiteralFalse.freeze
end
