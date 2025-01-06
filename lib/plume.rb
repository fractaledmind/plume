# frozen_string_literal: true

require "plume/version"
require "plume/lexer"
require "plume/ref"
require "plume/parser"

module Plume
	def self.tokenize(str)
		Lexer.new(str).tokenize
	end
end
