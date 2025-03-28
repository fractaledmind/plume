# frozen_string_literal: true

test "select * from tb0" do
	node = parse_stmt(<<~SQL)
		select * from tb0
	SQL

	assert_equal node.source.name, "tb0"
	assert_operator Plume::StarResultColumn, :===, node.columns[0]
end
