# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
	require "simplecov"

	SimpleCov.start do
		command_name "quickdraw"
		enable_coverage_for_eval
		enable_for_subprocesses true
		enable_coverage :branch
		add_filter %r{^/fixtures/}
	end
end

require "plume"

class Quickdraw::Test
	def assert_statement(sql, structure)
		parsed = parse(sql)
		assert_equal parsed, [structure]
	end

	def parse(sql)
		Plume::Parser.new(sql).parse
	end
end
