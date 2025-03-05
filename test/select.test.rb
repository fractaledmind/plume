# frozen_string_literal: true

test "parse a basic select" do
	node = parse_stmt(<<~SQL)
		select * from tb0
	SQL
end
