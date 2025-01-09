# frozen_string_literal: true

# test "Greater than comparison with positive integer" do
# 	parser = Plume::Parser.new("c0 > 0")
# 	expr = parser.Expression()
# 	assert_equal expr, { :GT=>["c0", 0] }
# end

# test "Compound AND condition with greater than and less than" do
# 	parser = Plume::Parser.new("c0 > 0 AND c1 < 0")
# 	expr = parser.Expression()
# 	assert_equal expr, {
# 		AND: [
# 			{ GT: ["c0", 0] },
# 			{ LT: ["c1", 0] },
# 		]
# 	}
# end

test "Greater than comparison with negative integer" do
	parser = Plume::Parser.new("c0 > -1")
	expr = parser.Expression()
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ABOVE,
		left: Plume::IdentifierExpression.new(value: "c0"),
		right: Plume::UnaryExpression.new(
			operator: :NEGATE,
			operand: 1
		),
	)
end

test "Greater than comparison with negative integer on left side" do
	parser = Plume::Parser.new("-1 > c0")
	expr = parser.Expression()
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ABOVE,
		left: Plume::UnaryExpression.new(
			operator: :NEGATE,
			operand: 1
		),
		right: Plume::IdentifierExpression.new(value: "c0"),
	)
end

# test "NOT operator with column reference" do
# 	parser = Plume::Parser.new("NOT c0")
# 	expr = parser.Expression()
# 	assert_equal expr, { :NOT=>"c0" }
# end

# test "NOT operator with addition expression" do
# 	parser = Plume::Parser.new("NOT 0 + 1")
# 	expr = parser.Expression()
# 	assert_equal expr, { :NOT=>{ :PLUS=>[0, 1] } }
# end

# test "BETWEEN operator with integer values" do
# 	parser = Plume::Parser.new("2 between 1 and 10")
# 	expr = parser.Expression()
# 	assert_equal expr, { :BETWEEN=>[2, 1, 10] }
# end

test "Single integer literal expression" do
	parser = Plume::Parser.new("2")
	expr = parser.Expression()
	assert_equal expr, 2
end

# test "LIKE operator with string literals" do
# 	parser = Plume::Parser.new("'str' like 'foo'")
# 	expr = parser.Expression()
# 	assert_equal expr, { :LIKE=>["'str'", "'foo'"] }
# end

# test "IN operator with list of values" do
# 	parser = Plume::Parser.new("c0 IN (1, 2, 3)")
# 	expr = parser.Expression()
# 	assert_equal expr, { "c0"=>{ :IN=>[1, 2, 3] } }
# end

# test "IS NULL operator" do
#  parser = Plume::Parser.new("c0 IS NULL")
#  expr = parser.Expression()
#  assert_equal expr, {:IS=>["c0", nil]}
# end

# test "IS NOT NULL operator" do
#  parser = Plume::Parser.new("c0 IS NOT NULL")
#  expr = parser.Expression()
#  assert_equal expr, {:IS_NOT=>["c0", nil]}
# end

# test "CASE expression" do
#  parser = Plume::Parser.new("CASE WHEN c0 > 0 THEN 'Positive' WHEN c0 < 0 THEN 'Negative' ELSE 'Zero' END")
#  expr = parser.Expression()
#  assert_equal expr, {:CASE=>{:WHEN=>[{:GT=>["c0", 0]}, "'Positive'"], :WHEN=>[{:LT=>["c0", 0]}, "'Negative'"], :ELSE=>"'Zero'"}}
# end

# test "Function call" do
#  parser = Plume::Parser.new("COUNT(*)")
#  expr = parser.Expression()
#  assert_equal expr, {:COUNT=>["*"]}
# end

# # test "Subquery in expression" do
# #  parser = Plume::Parser.new("c0 = (SELECT MAX(c1) FROM t1)")
# #  expr = parser.Expression()
# #  assert_equal expr, {:EQ=>["c0", {:SELECT=>{:columns=>[{:MAX=>["c1"]}], :from=>"t1"}}]}
# # end

# test "Complex nested expression" do
#  parser = Plume::Parser.new("(c0 + 5) * 2 > (SELECT AVG(c1) FROM t1) OR c2 IS NOT NULL")
#  expr = parser.Expression()
#  assert_equal expr, {:OR=>[{:GT=>[{:MULTIPLY=>[{:PLUS=>["c0", 5]}, 2]}, {:SELECT=>{:columns=>[{:AVG=>["c1"]}], :from=>"t1"}}]}, {:IS_NOT=>["c2", nil]}]}
# end

# test "GLOB operator" do
#  parser = Plume::Parser.new("c0 GLOB '*.txt'")
#  expr = parser.Expression()
#  assert_equal expr, {:GLOB=>["c0", "'*.txt'"]}
# end

# test "REGEXP operator" do
#  parser = Plume::Parser.new("c0 REGEXP '^[A-Z]+'")
#  expr = parser.Expression()
#  assert_equal expr, {:REGEXP=>["c0", "'^[A-Z]+'"]}
# end

# test "Bitwise operations" do
#  parser = Plume::Parser.new("c0 & 3 | 4")
#  expr = parser.Expression()
#  assert_equal expr, {:BITOR=>[{:BITAND=>["c0", 3]}, 4]}
# end
