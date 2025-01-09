# frozen_string_literal: true

require "plume/version"
require "plume/lexer"
require "plume/ref"
require "plume/parser"
require "literal"
require "plume/nodes"
require "plume/create_table_statement"
require "plume/expression"
require "plume/generator"

module Plume
	def self.tokenize(str)
		Lexer.new(str).tokenize
	end

	def self.parse(sql)
		Parser.new(sql).parse
	end
end
