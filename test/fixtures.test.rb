# frozen_string_literal: true

# Eventually, we should test a round-trip SQL -> AST -> SQL -> AST

require "timeout"

Dir.glob("./fixtures/**/*.sql") do |file_path|
	test file_path do
		refute_raises do
			sql = File.read(file_path)
			Plume::Parser.new(sql).parse
		end
	end
end
