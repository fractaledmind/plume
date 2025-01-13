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

test "Single unqualified column reference expression" do
	parser = Plume::Parser.new("c0")
	expr = parser.expression
	assert_equal expr, Plume::ColumnReference.new(column_name: "c0")
end

test "Single table-qualified column reference expression" do
	parser = Plume::Parser.new("tb1.c0")
	expr = parser.expression
	assert_equal expr, Plume::ColumnReference.new(
		table_name: "tb1",
		column_name: "c0",
	)
end

test "Single fully qualified column reference expression" do
	parser = Plume::Parser.new("sc1.tb1.c0")
	expr = parser.expression
	assert_equal expr, Plume::ColumnReference.new(
		schema_name: "sc1",
		table_name: "tb1",
		column_name: "c0",
	)
end

test "Parenthetical integer literal expression" do
	parser = Plume::Parser.new("(2)")
	expr = parser.expression
	assert_equal expr, 2
end

test "Parenthetical float literal expression" do
	parser = Plume::Parser.new("(1.2)")
	expr = parser.expression
	assert_equal expr, 1.2
end

test "Parenthetical string literal expression" do
	parser = Plume::Parser.new("('foo')")
	expr = parser.expression
	assert_equal expr, "foo"
end

test "Parenthetical blob literal expression" do
	parser = Plume::Parser.new("(X'53514C697465')")
	expr = parser.expression
	assert_equal expr, "SQLite"
end

test "Parenthetical NULL literal expression" do
	parser = Plume::Parser.new("(null)")
	expr = parser.expression
	assert_equal expr, nil
end

test "Parenthetical TRUE literal expression" do
	parser = Plume::Parser.new("(true)")
	expr = parser.expression
	assert_equal expr, true
end

test "Parenthetical FALSE literal expression" do
	parser = Plume::Parser.new("(false)")
	expr = parser.expression
	assert_equal expr, false
end

test "Parenthetical CURRENT_TIME literal expression" do
	parser = Plume::Parser.new("(current_time)")
	expr = parser.expression
	assert_equal expr, :CURRENT_TIME
end

test "Parenthetical CURRENT_DATE literal expression" do
	parser = Plume::Parser.new("(current_date)")
	expr = parser.expression
	assert_equal expr, :CURRENT_DATE
end

test "Parenthetical CURRENT_TIMESTAMP literal expression" do
	parser = Plume::Parser.new("(current_timestamp)")
	expr = parser.expression
	assert_equal expr, :CURRENT_TIMESTAMP
end

test "Parenthetical unqualified column reference expression" do
	parser = Plume::Parser.new("(c0)")
	expr = parser.expression
	assert_equal expr, Plume::ColumnReference.new(column_name: "c0")
end

test "Parenthetical table-qualified column reference expression" do
	parser = Plume::Parser.new("(tb1.c0)")
	expr = parser.expression
	assert_equal expr, Plume::ColumnReference.new(
		table_name: "tb1",
		column_name: "c0",
	)
end

test "Parenthetical fully qualified column reference expression" do
	parser = Plume::Parser.new("(sc1.tb1.c0)")
	expr = parser.expression
	assert_equal expr, Plume::ColumnReference.new(
		schema_name: "sc1",
		table_name: "tb1",
		column_name: "c0",
	)
end

# -- unary operations

test "Bitwise NOT operation" do
	parser = Plume::Parser.new("~c0")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :INVERT,
		operand: Plume::ColumnReference.new(column_name: "c0")
	)
end

test "Unary plus operation" do
	parser = Plume::Parser.new("+c0")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :IDENTITY,
		operand: Plume::ColumnReference.new(column_name: "c0")
	)
end

test "Unary minus operation" do
	parser = Plume::Parser.new("-c0")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :NEGATE,
		operand: Plume::ColumnReference.new(column_name: "c0")
	)
end

test "Logical NOT operation" do
	parser = Plume::Parser.new("NOT c0")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :NOT,
		operand: Plume::ColumnReference.new(column_name: "c0")
	)
end

test "ISNULL operator" do
	parser = Plume::Parser.new("c0 ISNULL")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :IS_NULL,
		operand: Plume::ColumnReference.new(column_name: "c0"),
	)
end

test "NOTNULL operator" do
	parser = Plume::Parser.new("c0 NOTNULL")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :NOT_NULL,
		operand: Plume::ColumnReference.new(column_name: "c0"),
	)
end

# -- binary operations

test "Binary concat operation" do
	parser = Plume::Parser.new("c0 || 'suffix'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :CONCAT,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "suffix",
	)
end

test "Binary extract operation" do
	parser = Plume::Parser.new("c0 -> '$.key'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :EXTRACT,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "$.key",
	)
end

test "Binary retrieve operation" do
	parser = Plume::Parser.new("c0 ->> '$.key'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :RETRIEVE,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "$.key",
	)
end

test "Multiplication operation" do
	parser = Plume::Parser.new("c0 * 5")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :MULTIPLY,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 5,
	)
end

test "Division operation" do
	parser = Plume::Parser.new("c0 / 2")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :DIVIDE,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 2,
	)
end

test "Modulo operation" do
	parser = Plume::Parser.new("c0 % 3")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :MODULO,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 3,
	)
end

test "Addition operation" do
	parser = Plume::Parser.new("c0 + 10")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ADD,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 10,
	)
end

test "Subtraction operation" do
	parser = Plume::Parser.new("c0 - 5")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :SUB,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 5,
	)
end

test "Bitwise AND operation" do
	parser = Plume::Parser.new("c0 & 7")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :BIT_AND,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 7,
	)
end

test "Bitwise OR operation" do
	parser = Plume::Parser.new("c0 | 8")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :BIT_OR,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 8,
	)
end

test "Bitwise left shift operation" do
	parser = Plume::Parser.new("c0 << 2")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :BIT_LSHIFT,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 2,
	)
end

test "Bitwise right shift operation" do
	parser = Plume::Parser.new("c0 >> 1")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :BIT_RSHIFT,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 1,
	)
end

test "Less than comparison" do
	parser = Plume::Parser.new("c0 < 100")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :BELOW,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 100,
	)
end

test "Less than or equal comparison" do
	parser = Plume::Parser.new("c0 <= 50")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ATMOST,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 50,
	)
end

test "Greater than or equal comparison" do
	parser = Plume::Parser.new("c0 >= 20")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ATLEAST,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 20,
	)
end

test "Equality comparison" do
	parser = Plume::Parser.new("c0 = 42")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :EQUALS,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 42,
	)
end

test "Inequality comparison" do
	parser = Plume::Parser.new("c0 != 42")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :NOT_EQUALS,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 42,
	)
end

test "IS comparison" do
	parser = Plume::Parser.new("c0 IS TRUE")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :IS,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: true,
	)
end

test "IS NOT comparison" do
	parser = Plume::Parser.new("c0 IS NOT FALSE")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :IS_NOT,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: false,
	)
end

test "Greater than comparison with positive integer" do
	parser = Plume::Parser.new("c0 > 0")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ABOVE,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: 0,
	)
end

test "Greater than comparison with negative integer" do
	parser = Plume::Parser.new("c0 > -1")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ABOVE,
		left: Plume::ColumnReference.new(column_name: "c0"),
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
		right: Plume::ColumnReference.new(column_name: "c0"),
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

test "LIKE operator with string literals and ESCAPE clause" do
	parser = Plume::Parser.new("'str' like 'foo' escape '|'")
	expr = parser.expression
	assert_equal expr, Plume::LikeExpression.new(
		left: "str",
		right: "foo",
		escape: "|",
	)
end

test "NOT LIKE operator with string literals and ESCAPE clause" do
	parser = Plume::Parser.new("'str' not like 'foo' escape '|'")
	expr = parser.expression
	assert_equal expr, Plume::NotLikeExpression.new(
		left: "str",
		right: "foo",
		escape: "|",
	)
end

test "IS NOT NULL operator" do
	parser = Plume::Parser.new("c0 IS NOT NULL")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :IS_NOT,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: nil
	)
end

test "GLOB operator" do
	parser = Plume::Parser.new("c0 GLOB '*.txt'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :GLOB,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "*.txt",
	)
end

test "REGEXP operator" do
	parser = Plume::Parser.new("c0 REGEXP '^[A-Z]+'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :REGEXP,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "^[A-Z]+",
	)
end

test "MATCH operator" do
	parser = Plume::Parser.new("c0 MATCH 'patten'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :MATCH,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "patten",
	)
end

test "NOT GLOB operator" do
	parser = Plume::Parser.new("c0 NOT GLOB '*.txt'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :NOT_GLOB,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "*.txt",
	)
end

test "NOT REGEXP operator" do
	parser = Plume::Parser.new("c0 NOT REGEXP '^[A-Z]+'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :NOT_REGEXP,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "^[A-Z]+",
	)
end

test "NOT MATCH operator" do
	parser = Plume::Parser.new("c0 NOT MATCH 'patten'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :NOT_MATCH,
		left: Plume::ColumnReference.new(column_name: "c0"),
		right: "patten",
	)
end

test "Compound AND condition with greater than and less than" do
	parser = Plume::Parser.new("c0 > 0 AND c1 < 0")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ALL,
		left: Plume::BinaryExpression.new(
			operator: :ABOVE,
			left: Plume::ColumnReference.new(column_name: "c0"),
			right: 0
		),
		right: Plume::BinaryExpression.new(
			operator: :BELOW,
			left: Plume::ColumnReference.new(column_name: "c1"),
			right: 0
		)
	)
end

test "Compound OR condition with greater than and less than" do
	parser = Plume::Parser.new("c0 > 0 OR c1 LIKE 'foo%'")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :ANY,
		left: Plume::BinaryExpression.new(
			operator: :ABOVE,
			left: Plume::ColumnReference.new(column_name: "c0"),
			right: 0
		),
		right: Plume::LikeExpression.new(
			left: Plume::ColumnReference.new(column_name: "c1"),
			right: "foo%"
		)
	)
end

test "NOT operator with column reference" do
	parser = Plume::Parser.new("NOT c0")
	expr = parser.expression
	assert_equal expr, Plume::UnaryExpression.new(
		operator: :NOT,
		operand: Plume::ColumnReference.new(column_name: "c0")
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

test "NOT BETWEEN operator with integer values" do
	parser = Plume::Parser.new("2 not between 1 and 10")
	expr = parser.expression
	assert_equal expr, Plume::TernaryExpression.new(
		operator: :NOT_BETWEEN,
		left: 2,
		middle: 1,
		right: 10
	)
end

test "IN operator with list of values" do
	parser = Plume::Parser.new("c0 IN (1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: [1, 2, 3]
	)
end

test "IN operator with empty parens" do
	parser = Plume::Parser.new("c0 IN ()")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: []
	)
end

test "IN operator with an unqualified table reference" do
	parser = Plume::Parser.new("c0 IN tb0")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::TableReference.new(
			table_name: "tb0"
		)
	)
end

test "IN operator with a qualified table reference" do
	parser = Plume::Parser.new("c0 IN sc0.tb0")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
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
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [],
			)
		)
	)
end

test "IN operator with a qualified function reference" do
	parser = Plume::Parser.new("c0 IN sc0.foobar()")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [],
			)
		)
	)
end

test "IN operator with an unqualified function reference with arguments" do
	parser = Plume::Parser.new("c0 IN foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [1, 2, 3],
			)
		)
	)
end

test "IN operator with a qualified function reference with arguments" do
	parser = Plume::Parser.new("c0 IN sc0.foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::InExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [1, 2, 3],
			)
		)
	)
end

test "NOT IN operator with list of values" do
	parser = Plume::Parser.new("c0 NOT IN (1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: [1, 2, 3]
	)
end

test "NOT IN operator with empty parens" do
	parser = Plume::Parser.new("c0 NOT IN ()")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: []
	)
end

test "NOT IN operator with an unqualified table reference" do
	parser = Plume::Parser.new("c0 NOT IN tb0")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::TableReference.new(
			table_name: "tb0"
		)
	)
end

test "NOT IN operator with a qualified table reference" do
	parser = Plume::Parser.new("c0 NOT IN sc0.tb0")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
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
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [],
			)
		)
	)
end

test "NOT IN operator with a qualified function reference" do
	parser = Plume::Parser.new("c0 NOT IN sc0.foobar()")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [],
			)
		)
	)
end

test "NOT IN operator with an unqualified function reference with arguments" do
	parser = Plume::Parser.new("c0 NOT IN foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [1, 2, 3],
			)
		)
	)
end

test "NOT IN operator with a qualified function reference with arguments" do
	parser = Plume::Parser.new("c0 NOT IN sc0.foobar(1, 2, 3)")
	expr = parser.expression
	assert_equal expr, Plume::NotInExpression.new(
		member: Plume::ColumnReference.new(column_name: "c0"),
		collection: Plume::FunctionReference.new(
			schema_name: "sc0",
			function_name: "foobar",
			arguments: Plume::FunctionArguments.new(
				expressions: [1, 2, 3],
			)
		)
	)
end

# -- CASE expressions

test "CASE expression without base expression but with ELSE" do
	parser = Plume::Parser.new("CASE WHEN c0 > 0 THEN 'Positive' WHEN c0 < 0 THEN 'Negative' ELSE 'Zero' END")
	expr = parser.expression
	assert_equal expr, Plume::CaseExpression.new(
		predicate: nil,
		conditions: [
			Plume::CaseCondition.new(
				predicate: Plume::BinaryExpression.new(
					operator: :ABOVE,
					left: Plume::ColumnReference.new(column_name: "c0"),
					right: 0
				),
				consequence: "Positive"
			),
			Plume::CaseCondition.new(
				predicate: Plume::BinaryExpression.new(
					operator: :BELOW,
					left: Plume::ColumnReference.new(column_name: "c0"),
					right: 0
				),
				consequence: "Negative"
			),
		],
		else_clause: "Zero"
	)
end

test "CASE expression without base expression and without ELSE" do
	parser = Plume::Parser.new("CASE WHEN c0 > 0 THEN 'Positive' WHEN c0 < 0 THEN 'Negative' END")
	expr = parser.expression
	assert_equal expr, Plume::CaseExpression.new(
		predicate: nil,
		conditions: [
			Plume::CaseCondition.new(
				predicate: Plume::BinaryExpression.new(
					operator: :ABOVE,
					left: Plume::ColumnReference.new(column_name: "c0"),
					right: 0
				),
				consequence: "Positive"
			),
			Plume::CaseCondition.new(
				predicate: Plume::BinaryExpression.new(
					operator: :BELOW,
					left: Plume::ColumnReference.new(column_name: "c0"),
					right: 0
				),
				consequence: "Negative"
			),
		],
	)
end

test "CASE expression with base expression and with ELSE" do
	parser = Plume::Parser.new("CASE x WHEN w1 THEN r1 WHEN w2 THEN r2 ELSE r3 END")
	expr = parser.expression
	assert_equal expr, Plume::CaseExpression.new(
		predicate: Plume::ColumnReference.new(column_name: "x"),
		conditions: [
			Plume::CaseCondition.new(
				predicate: Plume::ColumnReference.new(column_name: "w1"),
				consequence: Plume::ColumnReference.new(column_name: "r1")
			),
			Plume::CaseCondition.new(
				predicate: Plume::ColumnReference.new(column_name: "w2"),
				consequence: Plume::ColumnReference.new(column_name: "r2")
			),
		],
		else_clause: Plume::ColumnReference.new(column_name: "r3")
	)
end

test "CASE expression with base expression and without ELSE" do
	parser = Plume::Parser.new("CASE x WHEN w1 THEN r1 WHEN w2 THEN r2 END")
	expr = parser.expression
	assert_equal expr, Plume::CaseExpression.new(
		predicate: Plume::ColumnReference.new(column_name: "x"),
		conditions: [
			Plume::CaseCondition.new(
				predicate: Plume::ColumnReference.new(column_name: "w1"),
				consequence: Plume::ColumnReference.new(column_name: "r1")
			),
			Plume::CaseCondition.new(
				predicate: Plume::ColumnReference.new(column_name: "w2"),
				consequence: Plume::ColumnReference.new(column_name: "r2")
			),
		],
	)
end

# -- CAST expressions

test "CAST expression with integer type" do
	parser = Plume::Parser.new("CAST(c0 AS INTEGER)")
	expr = parser.expression
	assert_equal expr, Plume::CastExpression.new(
		expression: Plume::ColumnReference.new(column_name: "c0"),
		as: Plume::IntegerType.new(name: "INTEGER"),
	)
end

# -- function calls

test "Simple function call with no argument" do
	parser = Plume::Parser.new("CHANGES()")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :CHANGES,
		arguments: Plume::EmptyFunctionArgument.new
	)
end

test "Simple function call with single numeric expression argument" do
	parser = Plume::Parser.new("ABS(-1)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ABS,
		arguments: Plume::FunctionArguments.new(
			expressions: [
				Plume::UnaryExpression.new(
					operator: :NEGATE,
					operand: 1
				),
			]
		)
	)
end

test "Aggregate function call with STAR argument" do
	parser = Plume::Parser.new("COUNT(*)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::StarFunctionArgument.new
	)
end

test "Aggregate function call with STAR argument and filter clause" do
	parser = Plume::Parser.new("COUNT(*) FILTER (WHERE c0 > 0)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::StarFunctionArgument.new,
		filter_clause: Plume::BinaryExpression.new(
			operator: :ABOVE,
			left: Plume::ColumnReference.new(column_name: "c0"),
			right: 0
		)
	)
end

test "Aggregate function call with DISTINCT column reference argument" do
	parser = Plume::Parser.new("COUNT(DISTINCT c0)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			distinct: true,
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
			]
		)
	)
end

test "Aggregate function call with DISTINCT column reference arguments" do
	parser = Plume::Parser.new("COUNT(DISTINCT c0, c1)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			distinct: true,
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			]
		)
	)
end

test "Aggregate function call with DISTINCT column reference arguments and ORDER BY one column" do
	parser = Plume::Parser.new("COUNT(DISTINCT c0, c1 ORDER BY c0)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			distinct: true,
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0")
				),
			]
		)
	)
end

test "Aggregate function call with DISTINCT column reference arguments and ORDER BY one column with direction" do
	parser = Plume::Parser.new("COUNT(DISTINCT c0, c1 ORDER BY c0 DESC)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			distinct: true,
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0"),
					direction: :DESC,
				),
			]
		)
	)
end

test "Aggregate function call with DISTINCT column reference arguments and ORDER BY one column with direction and nulls last" do
	parser = Plume::Parser.new("COUNT(DISTINCT c0, c1 ORDER BY c0 DESC NULLS LAST)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			distinct: true,
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0"),
					direction: :DESC,
					nulls: :LAST,
				),
			]
		)
	)
end

test "Aggregate function call with DISTINCT column reference arguments and ORDER BY one column with direction and nulls first" do
	parser = Plume::Parser.new("COUNT(DISTINCT c0, c1 ORDER BY c0 DESC NULLS FIRST)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			distinct: true,
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0"),
					direction: :DESC,
					nulls: :FIRST,
				),
			]
		)
	)
end

test "Aggregate function call with column reference argument" do
	parser = Plume::Parser.new("COUNT(c0)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
			]
		)
	)
end

test "Aggregate function call with column reference arguments" do
	parser = Plume::Parser.new("COUNT(c0, c1)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			]
		)
	)
end

test "Aggregate function call with column reference arguments and ORDER BY one column" do
	parser = Plume::Parser.new("COUNT(c0, c1 ORDER BY c0)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0")
				),
			]
		)
	)
end

test "Aggregate function call with column reference arguments and ORDER BY one column with direction" do
	parser = Plume::Parser.new("COUNT(c0, c1 ORDER BY c0 DESC)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0"),
					direction: :DESC,
				),
			]
		)
	)
end

test "Aggregate function call with column reference arguments and ORDER BY one column with direction and nulls last" do
	parser = Plume::Parser.new("COUNT(c0, c1 ORDER BY c0 DESC NULLS LAST)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0"),
					direction: :DESC,
					nulls: :LAST,
				),
			]
		)
	)
end

test "Aggregate function call with column reference arguments and ORDER BY one column with direction and nulls first" do
	parser = Plume::Parser.new("COUNT(c0, c1 ORDER BY c0 DESC NULLS FIRST)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :COUNT,
		arguments: Plume::FunctionArguments.new(
			expressions: [
				Plume::ColumnReference.new(column_name: "c0"),
				Plume::ColumnReference.new(column_name: "c1"),
			],
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "c0"),
					direction: :DESC,
					nulls: :FIRST,
				),
			]
		)
	)
end

test "Window function call with no arguments and empty window" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER ()")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new
	)
end

test "Window function call with no arguments and window name" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER win1")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			window_name: "win1"
		)
	)
end

test "Window function call with no arguments and window definition with only PARTITION BY" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (PARTITION BY y)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			partition_by: [
				Plume::ColumnReference.new(column_name: "y"),
			]
		)
	)
end

test "Window function call with no arguments and window definition with only ORDER BY" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ORDER BY y)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			order_by: [
				Plume::OrderingTerm.new(
					expression: Plume::ColumnReference.new(column_name: "y")
				),
			]
		)
	)
end

test "Window function call with no arguments and window definition with RANGE UNBOUNDED PRECEDING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (RANGE UNBOUNDED PRECEDING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :RANGE,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS UNBOUNDED PRECEDING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS UNBOUNDED PRECEDING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with GROUPS UNBOUNDED PRECEDING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (GROUPS UNBOUNDED PRECEDING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :GROUPS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS CURRENT ROW frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS CURRENT ROW)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :CURRENT_ROW,
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS <expr> PRECEDING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS 123 PRECEDING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: 123
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN UNBOUNDED PRECEDING AND <expr> PRECEDING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND 123 PRECEDING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: :UNBOUNDED
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: 123
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: :UNBOUNDED
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :CURRENT_ROW,
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN UNBOUNDED PRECEDING AND <expr> FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND 123 FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: :UNBOUNDED
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: 123
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: :UNBOUNDED
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN <expr> PRECEDING AND <expr> PRECEDING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN 123 PRECEDING AND 123 PRECEDING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: 123
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: 123
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN <expr> PRECEDING AND CURRENT ROW frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN 123 PRECEDING AND CURRENT ROW)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: 123
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :CURRENT_ROW,
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN <expr> PRECEDING AND 123 FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN 123 PRECEDING AND 123 FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: 123
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: 123
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN <expr> PRECEDING AND UNBOUNDED FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN 123 PRECEDING AND UNBOUNDED FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :PRECEDING,
					value: 123
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN CURRENT ROW AND CURRENT ROW frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN CURRENT ROW AND CURRENT ROW)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :CURRENT_ROW,
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :CURRENT_ROW,
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN CURRENT ROW AND 123 FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN CURRENT ROW AND 123 FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :CURRENT_ROW,
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: 123
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :CURRENT_ROW,
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN <expr> FOLLOWING AND 123 FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN 123 FOLLOWING AND 123 FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: 123
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: 123
				),
			)
		)
	)
end

test "Window function call with no arguments and window definition with ROWS BETWEEN <expr> FOLLOWING AND UNBOUNDED FOLLOWING frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (ROWS BETWEEN 123 FOLLOWING AND UNBOUNDED FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: 123
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

test "Window function call with no arguments and base window name with ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW frame spec without exclude clause" do
	parser = Plume::Parser.new("ROW_NUMBER() OVER (win ROWS BETWEEN 123 FOLLOWING AND UNBOUNDED FOLLOWING)")
	expr = parser.expression
	assert_equal expr, Plume::FunctionReference.new(
		function_name: :ROW_NUMBER,
		arguments: Plume::EmptyFunctionArgument.new,
		over_clause: Plume::OverClause.new(
			base_window_name: "win",
			frame: Plume::FrameSpec.new(
				type: :ROWS,
				starting_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: 123
				),
				ending_boundary: Plume::FrameBoundary.new(
					type: :FOLLOWING,
					value: :UNBOUNDED
				),
			)
		)
	)
end

# test "Subquery in expression" do
# 	parser = Plume::Parser.new("c0 = (SELECT MAX(c1) FROM t1)")
# 	expr = parser.expression
# 	assert_equal expr, {:EQ=>["c0", {:SELECT=>{:columns=>[{:MAX=>["c1"]}], :from=>"t1"}}]}
# end

# test "Complex nested expression" do
# 	parser = Plume::Parser.new("(c0 + 5) * 2 > (SELECT AVG(c1) FROM t1) OR c2 IS NOT NULL")
# 	expr = parser.expression
# 	assert_equal expr, {:OR=>[{:GT=>[{:MULTIPLY=>[{:PLUS=>["c0", 5]}, 2]}, {:SELECT=>{:columns=>[{:AVG=>["c1"]}], :from=>"t1"}}]}, {:IS_NOT=>["c2", nil]}]}
# end

test "Bitwise operations" do
	parser = Plume::Parser.new("c0 & 3 | 4")
	expr = parser.expression
	assert_equal expr, Plume::BinaryExpression.new(
		operator: :BIT_OR,
		left: Plume::BinaryExpression.new(
			operator: :BIT_AND,
			left: Plume::ColumnReference.new(column_name: "c0"),
			right: 3,
		),
		right: 4,
	)
end
