# frozen_string_literal: true

# -- literal values

test "Single integer literal expression" do
	parser = Plume::Parser.new("2")
	expr = parser.expression
	assert_equal expr, 2
end

test "Single float literal expression" do
	parser = Plume::Parser.new("1.2")
	expr = parser.expression
	assert_equal expr, 1.2
end

test "Single string literal expression" do
	parser = Plume::Parser.new("'foo'")
	expr = parser.expression
	assert_equal expr, "foo"
end

test "Single blob literal expression" do
	parser = Plume::Parser.new("X'53514C697465'")
	expr = parser.expression
	assert_equal expr, "SQLite"
end

test "Single NULL literal expression" do
	parser = Plume::Parser.new("null")
	expr = parser.expression
	assert_equal expr, nil
end

test "Single TRUE literal expression" do
	parser = Plume::Parser.new("true")
	expr = parser.expression
	assert_equal expr, true
end

test "Single FALSE literal expression" do
	parser = Plume::Parser.new("false")
	expr = parser.expression
	assert_equal expr, false
end

test "Single CURRENT_TIME literal expression" do
	parser = Plume::Parser.new("current_time")
	expr = parser.expression
	assert_equal expr, :CURRENT_TIME
end

test "Single CURRENT_DATE literal expression" do
	parser = Plume::Parser.new("current_date")
	expr = parser.expression
	assert_equal expr, :CURRENT_DATE
end

test "Single CURRENT_TIMESTAMP literal expression" do
	parser = Plume::Parser.new("current_timestamp")
	expr = parser.expression
	assert_equal expr, :CURRENT_TIMESTAMP
end

# -- unary operations

test "Bitwise NOT operation" do
 parser = Plume::Parser.new("~c0")
 expr = parser.expression
 assert_equal expr, Plume::UnaryExpression.new(
  operator: :INVERT,
  operand: Plume::Identifier.new(value: "c0")
 )
end

test "Unary plus operation" do
 parser = Plume::Parser.new("+c0")
 expr = parser.expression
 assert_equal expr, Plume::UnaryExpression.new(
  operator: :IDENTITY,
  operand: Plume::Identifier.new(value: "c0")
 )
end

test "Unary minus operation" do
 parser = Plume::Parser.new("-c0")
 expr = parser.expression
 assert_equal expr, Plume::UnaryExpression.new(
  operator: :NEGATE,
  operand: Plume::Identifier.new(value: "c0")
 )
end

test "Logical NOT operation" do
 parser = Plume::Parser.new("NOT c0")
 expr = parser.expression
 assert_equal expr, Plume::UnaryExpression.new(
  operator: :NOT,
  operand: Plume::Identifier.new(value: "c0")
 )
end

test "ISNULL operator" do
	parser = Plume::Parser.new("c0 ISNULL")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :IS_NULL,
		operand: Plume::Identifier.new(value: "c0"),
	)
end

test "NOTNULL operator" do
	parser = Plume::Parser.new("c0 NOTNULL")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :NOT_NULL,
		operand: Plume::Identifier.new(value: "c0"),
	)
end

# -- binary operations

test "Binary concat operation" do
	parser = Plume::Parser.new("c0 || 'suffix'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :CONCAT,
		left: Plume::Identifier.new(value: "c0"),
		right: "suffix",
	)
end

test "Binary extract operation" do
	parser = Plume::Parser.new("c0 -> '$.key'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :EXTRACT,
		left: Plume::Identifier.new(value: "c0"),
		right: "$.key",
	)
end

test "Binary retrieve operation" do
 parser = Plume::Parser.new("c0 ->> '$.key'")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :RETRIEVE,
  left: Plume::Identifier.new(value: "c0"),
  right: "$.key",
 )
end

test "Multiplication operation" do
 parser = Plume::Parser.new("c0 * 5")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :MULTIPLY,
  left: Plume::Identifier.new(value: "c0"),
  right: 5,
 )
end

test "Division operation" do
 parser = Plume::Parser.new("c0 / 2")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :DIVIDE,
  left: Plume::Identifier.new(value: "c0"),
  right: 2,
 )
end

test "Modulo operation" do
 parser = Plume::Parser.new("c0 % 3")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :MODULO,
  left: Plume::Identifier.new(value: "c0"),
  right: 3,
 )
end

test "Addition operation" do
 parser = Plume::Parser.new("c0 + 10")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :ADD,
  left: Plume::Identifier.new(value: "c0"),
  right: 10,
 )
end

test "Subtraction operation" do
 parser = Plume::Parser.new("c0 - 5")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :SUB,
  left: Plume::Identifier.new(value: "c0"),
  right: 5,
 )
end

test "Bitwise AND operation" do
 parser = Plume::Parser.new("c0 & 7")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :BIT_AND,
  left: Plume::Identifier.new(value: "c0"),
  right: 7,
 )
end

test "Bitwise OR operation" do
 parser = Plume::Parser.new("c0 | 8")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :BIT_OR,
  left: Plume::Identifier.new(value: "c0"),
  right: 8,
 )
end

test "Bitwise left shift operation" do
 parser = Plume::Parser.new("c0 << 2")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :BIT_LSHIFT,
  left: Plume::Identifier.new(value: "c0"),
  right: 2,
 )
end

test "Bitwise right shift operation" do
 parser = Plume::Parser.new("c0 >> 1")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :BIT_RSHIFT,
  left: Plume::Identifier.new(value: "c0"),
  right: 1,
 )
end

test "Less than comparison" do
 parser = Plume::Parser.new("c0 < 100")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :BELOW,
  left: Plume::Identifier.new(value: "c0"),
  right: 100,
 )
end

test "Less than or equal comparison" do
 parser = Plume::Parser.new("c0 <= 50")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :ATMOST,
  left: Plume::Identifier.new(value: "c0"),
  right: 50,
 )
end

test "Greater than or equal comparison" do
 parser = Plume::Parser.new("c0 >= 20")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :ATLEAST,
  left: Plume::Identifier.new(value: "c0"),
  right: 20,
 )
end

test "Equality comparison" do
 parser = Plume::Parser.new("c0 = 42")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :EQUALS,
  left: Plume::Identifier.new(value: "c0"),
  right: 42,
 )
end

test "Inequality comparison" do
 parser = Plume::Parser.new("c0 != 42")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :NOT_EQUALS,
  left: Plume::Identifier.new(value: "c0"),
  right: 42,
 )
end

test "IS comparison" do
 parser = Plume::Parser.new("c0 IS TRUE")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :IS,
  left: Plume::Identifier.new(value: "c0"),
  right: true,
 )
end

test "IS NOT comparison" do
 parser = Plume::Parser.new("c0 IS NOT FALSE")
 expr = parser.expression
 assert_equal expr, Plume::BinaryExpression.new(
  operator: :IS_NOT,
  left: Plume::Identifier.new(value: "c0"),
  right: false,
 )
end

test "Greater than comparison with positive integer" do
	parser = Plume::Parser.new("c0 > 0")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ABOVE,
		left: Plume::Identifier.new(value: "c0"),
		right: 0,
	)
end

test "Greater than comparison with negative integer" do
	parser = Plume::Parser.new("c0 > -1")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ABOVE,
		left: Plume::Identifier.new(value: "c0"),
		right: Plume::UnaryExpression.new(
			operator: :NEGATE,
			operand: 1
		),
	)
end

test "Greater than comparison with negative integer on left side" do
	parser = Plume::Parser.new("-1 > c0")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ABOVE,
		left: Plume::UnaryExpression.new(
			operator: :NEGATE,
			operand: 1
		),
		right: Plume::Identifier.new(value: "c0"),
	)
end

test "LIKE operator with string literals" do
	parser = Plume::Parser.new("'str' like 'foo'")
	expr = parser.expression
	assert_equal expr, Plume::LikeExpression.new(
		left: "str",
		right: "foo",
	)
end

test "NOT LIKE operator with string literals" do
	parser = Plume::Parser.new("'str' not like 'foo'")
	expr = parser.expression
	assert_equal expr, Plume::NotLikeExpression.new(
		left: "str",
		right: "foo",
	)
end

test "IS NOT NULL operator" do
	parser = Plume::Parser.new("c0 IS NOT NULL")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :IS_NOT,
		left: Plume::Identifier.new(value: "c0"),
		right: nil
	)
end

test "GLOB operator" do
	parser = Plume::Parser.new("c0 GLOB '*.txt'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :GLOB,
		left: Plume::Identifier.new(value: "c0"),
		right: "*.txt",
	)
end

test "REGEXP operator" do
	parser = Plume::Parser.new("c0 REGEXP '^[A-Z]+'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :REGEXP,
		left: Plume::Identifier.new(value: "c0"),
		right: "^[A-Z]+",
	)
end

test "MATCH operator" do
	parser = Plume::Parser.new("c0 MATCH 'patten'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :MATCH,
		left: Plume::Identifier.new(value: "c0"),
		right: "patten",
	)
end

test "NOT GLOB operator" do
	parser = Plume::Parser.new("c0 NOT GLOB '*.txt'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :NOT_GLOB,
		left: Plume::Identifier.new(value: "c0"),
		right: "*.txt",
	)
end

test "NOT REGEXP operator" do
	parser = Plume::Parser.new("c0 NOT REGEXP '^[A-Z]+'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :NOT_REGEXP,
		left: Plume::Identifier.new(value: "c0"),
		right: "^[A-Z]+",
	)
end

test "NOT MATCH operator" do
	parser = Plume::Parser.new("c0 NOT MATCH 'patten'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :NOT_MATCH,
		left: Plume::Identifier.new(value: "c0"),
		right: "patten",
	)
end


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

test "NOT operator with column reference" do
	parser = Plume::Parser.new("NOT c0")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :NOT,
		operand: Plume::Identifier.new(
			value: "c0"
		)
	)
end

test "NOT operator with addition expression" do
	parser = Plume::Parser.new("NOT 0 + 1")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :NOT,
		operand: Plume::BinaryExpression.new(
			operator: :ADD,
			left: 0,
			right: 1
		)
	)
end

test "BETWEEN operator with integer values" do
	parser = Plume::Parser.new("2 between 1 and 10")
	expr = parser.expression
	assert_equal expr, Plume::TernaryExpression.new(
		operator: :BETWEEN,
		left: 2,
		middle: 1,
		right: 10
	)
end

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

test "Bitwise operations" do
	parser = Plume::Parser.new("c0 & 3 | 4")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :BIT_OR,
		left: Plume::BinaryExpression.new(
			operator: :BIT_AND,
			left: Plume::Identifier.new(
				value: "c0"
			),
			right: 3,
		),
		right: 4,
	)
end
