# frozen_string_literal: true

# test "Greater than comparison with positive integer" do
# 	parser = Plume::Parser.new("c0 > 0")
# 	expr = parser.expression
# 	assert_equal expr, Plume::BinaryExpression.new(
# 		operator: :ABOVE,
# 		left: Plume::Identifier.new(value: "c0"),
# 		right: 0,
# 	)
# end

# # test "Compound AND condition with greater than and less than" do
# # 	parser = Plume::Parser.new("c0 > 0 AND c1 < 0")
# # 	expr = parser.expression
# # 	assert_equal expr, {
# # 		AND: [
# # 			{ GT: ["c0", 0] },
# # 			{ LT: ["c1", 0] },
# # 		]
# # 	}
# # end

# # test "Greater than comparison with negative integer" do
# # 	parser = Plume::Parser.new("c0 > -1")
# # 	expr = parser.expression
# # 	assert_equal expr, Plume::BinaryExpression.new(
# # 		operator: :ABOVE,
# # 		left: Plume::Identifier.new(value: "c0"),
# # 		right: Plume::UnaryExpression.new(
# # 			operator: :NEGATE,
# # 			operand: 1
# # 		),
# # 	)
# # end

# test "Greater than comparison with negative integer on left side" do
# 	parser = Plume::Parser.new("-1 > c0")
# 	expr = parser.expression
# 	assert_equal expr, Plume::BinaryExpression.new(
# 		operator: :ABOVE,
# 		left: Plume::UnaryExpression.new(
# 			operator: :NEGATE,
# 			operand: 1
# 		),
# 		right: Plume::Identifier.new(value: "c0"),
# 	)
# end

# test "NOT operator with column reference" do
# 	parser = Plume::Parser.new("NOT c0")
# 	expr = parser.expression
# 	assert_equal expr, Plume::UnaryExpression.new(
# 		operator: :NOT,
# 		operand: Plume::Identifier.new(
# 			value: "c0"
# 		)
# 	)
# end

# test "NOT operator with addition expression" do
# 	parser = Plume::Parser.new("NOT 0 + 1")
# 	expr = parser.expression
# 	assert_equal expr, Plume::UnaryExpression.new(
# 		operator: :NOT,
# 		operand: Plume::BinaryExpression.new(
# 			operator: :ADD,
# 			left: 0,
# 			right: 1
# 		)
# 	)
# end

# test "BETWEEN operator with integer values" do
# 	parser = Plume::Parser.new("2 between 1 and 10")
# 	expr = parser.expression
# 	assert_equal expr, Plume::TernaryExpression.new(
# 		operator: :BETWEEN,
# 		left: 2,
# 		middle: 1,
# 		right: 10
# 	)
# end

# test "Single integer literal expression" do
# 	parser = Plume::Parser.new("2")
# 	expr = parser.expression
# 	assert_equal expr, 2
# end

# test "LIKE operator with string literals" do
# 	parser = Plume::Parser.new("'str' like 'foo'")
# 	expr = parser.expression
# 	assert_equal expr, Plume::LikeExpression.new(
# 		left: "str",
# 		right: "foo",
# 	)
# end

test "IN operator with list of values" do
	parser = Plume::Parser.new("c0 IN (1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: [1, 2, 3]
	)
end

test "IN operator with empty parens" do
	parser = Plume::Parser.new("c0 IN ()")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: []
	)
end

test "IN operator with an unqualified table reference" do
	parser = Plume::Parser.new("c0 IN tb0")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::TableReference.new(
			table_name: "tb0"
		)
	)
end

test "IN operator with a qualified table reference" do
	parser = Plume::Parser.new("c0 IN sc0.tb0")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::TableReference.new(
			schema_name: "sc0",
			table_name: "tb0",
		)
	)
end

test "IN operator with an unqualified function reference" do
	parser = Plume::Parser.new("c0 IN foobar()")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: [],
		)
	)
end

test "IN operator with a qualified function reference" do
	parser = Plume::Parser.new("c0 IN sc0.foobar()")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: [],
		)
	)
end

test "IN operator with an unqualified function reference with arguments" do
	parser = Plume::Parser.new("c0 IN foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: [1, 2, 3],
		)
	)
end

test "IN operator with a qualified function reference with arguments" do
	parser = Plume::Parser.new("c0 IN sc0.foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: [1, 2, 3],
		)
	)
end

test "NOT IN operator with list of values" do
	parser = Plume::Parser.new("c0 NOT IN (1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: [1, 2, 3]
	)
end

test "NOT IN operator with empty parens" do
	parser = Plume::Parser.new("c0 NOT IN ()")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: []
	)
end

test "NOT IN operator with an unqualified table reference" do
	parser = Plume::Parser.new("c0 NOT IN tb0")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::TableReference.new(
			table_name: "tb0"
		)
	)
end

test "NOT IN operator with a qualified table reference" do
	parser = Plume::Parser.new("c0 NOT IN sc0.tb0")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::TableReference.new(
			schema_name: "sc0",
			table_name: "tb0",
		)
	)
end

test "NOT IN operator with an unqualified function reference" do
	parser = Plume::Parser.new("c0 NOT IN foobar()")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: [],
		)
	)
end

test "NOT IN operator with a qualified function reference" do
	parser = Plume::Parser.new("c0 NOT IN sc0.foobar()")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: [],
		)
	)
end

test "NOT IN operator with an unqualified function reference with arguments" do
	parser = Plume::Parser.new("c0 NOT IN foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: [1, 2, 3],
		)
	)
end

test "NOT IN operator with a qualified function reference with arguments" do
	parser = Plume::Parser.new("c0 NOT IN sc0.foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::Identifier.new(value: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: [1, 2, 3],
		)
	)
end

# test "IS NULL operator" do
#  parser = Plume::Parser.new("c0 IS NULL")
#  expr = parser.expression
#  assert_equal expr, {:IS=>["c0", nil]}
# end

# test "IS NOT NULL operator" do
#  parser = Plume::Parser.new("c0 IS NOT NULL")
#  expr = parser.expression
#  assert_equal expr, {:IS_NOT=>["c0", nil]}
# end

# test "CASE expression" do
#  parser = Plume::Parser.new("CASE WHEN c0 > 0 THEN 'Positive' WHEN c0 < 0 THEN 'Negative' ELSE 'Zero' END")
#  expr = parser.expression
#  assert_equal expr, {:CASE=>{:WHEN=>[{:GT=>["c0", 0]}, "'Positive'"], :WHEN=>[{:LT=>["c0", 0]}, "'Negative'"], :ELSE=>"'Zero'"}}
# end

# test "Function call" do
#  parser = Plume::Parser.new("COUNT(*)")
#  expr = parser.expression
#  assert_equal expr, {:COUNT=>["*"]}
# end

# # test "Subquery in expression" do
# #  parser = Plume::Parser.new("c0 = (SELECT MAX(c1) FROM t1)")
# #  expr = parser.expression
# #  assert_equal expr, {:EQ=>["c0", {:SELECT=>{:columns=>[{:MAX=>["c1"]}], :from=>"t1"}}]}
# # end

# test "Complex nested expression" do
#  parser = Plume::Parser.new("(c0 + 5) * 2 > (SELECT AVG(c1) FROM t1) OR c2 IS NOT NULL")
#  expr = parser.expression
#  assert_equal expr, {:OR=>[{:GT=>[{:MULTIPLY=>[{:PLUS=>["c0", 5]}, 2]}, {:SELECT=>{:columns=>[{:AVG=>["c1"]}], :from=>"t1"}}]}, {:IS_NOT=>["c2", nil]}]}
# end

# test "GLOB operator" do
#  parser = Plume::Parser.new("c0 GLOB '*.txt'")
#  expr = parser.expression
#  assert_equal expr, {:GLOB=>["c0", "'*.txt'"]}
# end

# test "REGEXP operator" do
#  parser = Plume::Parser.new("c0 REGEXP '^[A-Z]+'")
#  expr = parser.expression
#  assert_equal expr, {:REGEXP=>["c0", "'^[A-Z]+'"]}
# end

# test "Bitwise operations" do
# 	parser = Plume::Parser.new("c0 & 3 | 4")
# 	expr = parser.expression
# 	assert_equal expr, Plume::BinaryExpression.new(
# 		operator: :BIT_OR,
# 		left: Plume::BinaryExpression.new(
# 			operator: :BIT_AND,
# 			left: Plume::Identifier.new(
# 				value: "c0"
# 			),
# 			right: 3,
# 		),
# 		right: 4,
# 	)
# end
