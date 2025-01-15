# frozen_string_literal: true

# Eventually, we should test a round-trip SQL -> AST -> SQL -> AST

# require "timeout"

# Dir.glob("./fixtures/**/*.sql") do |file_path|
# 	test file_path do
# 		sql = File.read(file_path)

# 		begin
# 			Timeout.timeout(1) do
# 				Plume::Parser.new(sql).parse
# 			end
# 		rescue Timeout::Error
# 			puts file_path
# 		end
# 	end
# end

test "it works" do
	Plume::Parser.new("CREATE TABLE a1(message_id, name , UNIQUE(message_id, name) );").parse
end
