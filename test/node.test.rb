# frozen_string_literal: true

test "Single integer literal expression" do
	node = Plume::LiteralExpression.new(
		value: 2
	)
	assert node.inspect.match?(/#<Plume::LiteralExpression:\d+ value=2>/)
end
