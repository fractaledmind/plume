# frozen_string_literal: true

test "error when parsing a create table with no columns" do
	error = assert_raises(Plume::SyntaxError) do
		parse_stmt(<<~SQL)
			create table tb0 ()
		SQL
	end

	assert_equal error.message.split("\n"), [
		'Unexpected token RP[")"] at:',
		"  create table tb0 ()",
		"                    ^",
		"  Expected one of: STRING, ID, INDEXED, CROSS, FULL, INNER, LEFT, NATURAL, OUTER, RIGHT",
	]
end

test "parse a basic create table with one column" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
end

test "parse a basic create table with schema and one column" do
	node = parse_stmt(<<~SQL)
		create table schema0.tb0 (c0)
	SQL

	assert_equal node.schema_name, "schema0"
	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
end

test "parse a basic create table with one column and double-quoted identifiers" do
	node = parse_stmt(<<~SQL)
		create table "tb0" ("c0")
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
end

test "parse a basic create table with one column and single-quoted identifiers" do
	node = parse_stmt(<<~SQL)
		create table 'tb0' ('c0')
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
end

test "parse a basic create table with one column and tick-quoted identifiers" do
	node = parse_stmt(<<~SQL)
		create table `tb0` (`c0`)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
end

test "parse a basic create table with one column and bracket-quoted identifiers" do
	node = parse_stmt(<<~SQL)
		create table [tb0] ([c0])
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
end

test "parse a basic create temp table with one column" do
	node = parse_stmt(<<~SQL)
		create temp table tb0 (c0)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_equal node.temporary, true
end

test "parse a basic temporary create table with one column" do
	node = parse_stmt(<<~SQL)
		create temporary table tb0 (c0)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_equal node.temporary, true
end

test "parse a basic create table if not exists with one column" do
	node = parse_stmt(<<~SQL)
		create table if not exists tb0 (c0)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_equal node.if_not_exists, true
end

test "parse a basic create temp table if not exists with one column" do
	node = parse_stmt(<<~SQL)
		create temp table if not exists tb0 (c0)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_equal node.temporary, true
	assert_equal node.if_not_exists, true
end

# column types

test "parse a basic create table with one column with a int type" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 int)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::IntegerType, :===, node.columns[0].type_name
	assert_equal node.columns[0].type_name.name, "int"
end

test "parse a basic create table with one column with a char type" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 char)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::TextType, :===, node.columns[0].type_name
	assert_equal node.columns[0].type_name.name, "char"
end

test "parse a basic create table with one column with a blob type" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 blob)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::BlobType, :===, node.columns[0].type_name
	assert_equal node.columns[0].type_name.name, "blob"
end

test "parse a basic create table with one column with a real type" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 real)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::RealType, :===, node.columns[0].type_name
	assert_equal node.columns[0].type_name.name, "real"
end

test "parse a basic create table with one column with a any type" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 any)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::AnyType, :===, node.columns[0].type_name
	assert_equal node.columns[0].type_name.name, "any"
end

test "parse a basic create table with one column with a constrained type" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 decimal(4, 6))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::AnyType, :===, node.columns[0].type_name
	assert_equal node.columns[0].type_name.name, "decimal"
	assert_equal node.columns[0].type_name.constraints, [4, 6]
end

# column constraints

test "parse basic create table with one column and a primary key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 primary key)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::PrimaryKeyColumnConstraint, :===, node.columns[0].constraints[0]
end

test "parse basic create table with one column and a named primary key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' primary key)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::PrimaryKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a primary key constraint with options" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 primary key desc on conflict abort autoincrement)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::PrimaryKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].direction, :DESC
	assert_equal node.columns[0].constraints[0].conflict_clause, :ABORT
	assert_equal node.columns[0].constraints[0].autoincrement, true
end

test "parse basic create table with one column and a named primary key constraint with options" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' primary key desc on conflict abort autoincrement)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::PrimaryKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].name, "name"
	assert_equal node.columns[0].constraints[0].direction, :DESC
	assert_equal node.columns[0].constraints[0].conflict_clause, :ABORT
	assert_equal node.columns[0].constraints[0].autoincrement, true
end

test "parse basic create table with one column and a not null constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 not null)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::NotNullColumnConstraint, :===, node.columns[0].constraints[0]
end

test "parse basic create table with one column and a named not null constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' not null)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::NotNullColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a not null constraint with options" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 not null on conflict abort)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::NotNullColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].conflict_clause, :ABORT
end

test "parse basic create table with one column and a named not null constraint with options" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' not null on conflict abort)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::NotNullColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].name, "name"
	assert_equal node.columns[0].constraints[0].conflict_clause, :ABORT
end

test "parse basic create table with one column and a unique constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 unique)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::UniqueColumnConstraint, :===, node.columns[0].constraints[0]
end

test "parse basic create table with one column and a named unique constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' unique)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::UniqueColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a unique constraint with options" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 unique on conflict abort)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::UniqueColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].conflict_clause, :ABORT
end

test "parse basic create table with one column and a named unique constraint with options" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' unique on conflict abort)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::UniqueColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].name, "name"
	assert_equal node.columns[0].constraints[0].conflict_clause, :ABORT
end

test "parse basic create table with one column and a check constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 check (c0 > 0))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::CheckColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ABOVE
	assert_equal node.columns[0].constraints[0].expression.left, Plume::ColumnReference.new(column_name: "c0")
	assert_equal node.columns[0].constraints[0].expression.right, 0
end

test "parse basic create table with one column and a named check constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' check (c0 > 0))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::CheckColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].name, "name"
	assert_equal node.columns[0].constraints[0].expression.operator, :ABOVE
	assert_equal node.columns[0].constraints[0].expression.left, Plume::ColumnReference.new(column_name: "c0")
	assert_equal node.columns[0].constraints[0].expression.right, 0
end

test "parse basic create table with one column and a default signed number" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 default 123)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::DefaultColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].value, 123
end

test "parse basic create table with one column and a named default signed number" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' default 123)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::DefaultColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].value, 123
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a default literal value" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 default 'foo')
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::DefaultColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].value, "foo"
end

test "parse basic create table with one column and a named default literal value" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' default 'foo')
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::DefaultColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].value, "foo"
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a default expression" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 default ('a' || 'b'))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::DefaultColumnConstraint, :===, node.columns[0].constraints[0]
	assert_operator Plume::BinaryExpression, :===, node.columns[0].constraints[0].value
	assert_equal node.columns[0].constraints[0].value.operator, :CONCAT
	assert_equal node.columns[0].constraints[0].value.left, "a"
	assert_equal node.columns[0].constraints[0].value.right, "b"
end

test "parse basic create table with one column and a named default expression" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' default ('a' || 'b'))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::DefaultColumnConstraint, :===, node.columns[0].constraints[0]
	assert_operator Plume::BinaryExpression, :===, node.columns[0].constraints[0].value
	assert_equal node.columns[0].constraints[0].value.operator, :CONCAT
	assert_equal node.columns[0].constraints[0].value.left, "a"
	assert_equal node.columns[0].constraints[0].value.right, "b"
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a collate constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 collate rtrim)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::CollateColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].collation_name, :RTRIM
end

test "parse basic create table with one column and a named collate constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' collate rtrim)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::CollateColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].collation_name, :RTRIM
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a generated as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 generated always as (1 + 2))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
end

test "parse basic create table with one column and a named generated as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' generated always as (1 + 2))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and an as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 as (1 + 2))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
end

test "parse basic create table with one column and a named as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' as (1 + 2))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a stored generated as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 generated always as (1 + 2) stored)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :STORED
end

test "parse basic create table with one column and a stored generated as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' generated always as (1 + 2) stored)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :STORED
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a stored as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 as (1 + 2) stored)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :STORED
end

test "parse basic create table with one column and a named stored as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' as (1 + 2) stored)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :STORED
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a virtual generated as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 generated always as (1 + 2) virtual)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :VIRTUAL
end

test "parse basic create table with one column and a named virtual generated as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' generated always as (1 + 2) virtual)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :VIRTUAL
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a virtual as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 as (1 + 2) virtual)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :VIRTUAL
end

test "parse basic create table with one column and a virtual as constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' as (1 + 2) virtual)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::GeneratedAsColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].expression.operator, :ADD
	assert_equal node.columns[0].constraints[0].expression.left, 1
	assert_equal node.columns[0].constraints[0].expression.right, 2
	assert_equal node.columns[0].constraints[0].type, :VIRTUAL
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
end

test "parse basic create table with one column and a named foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 constraint 'name' references tb1(c1))
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].name, "name"
end

test "parse basic create table with one column and a foreign key constraint with on delete set null" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on delete set null)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_delete, :SET_NULL
end

test "parse basic create table with one column and a foreign key constraint with on delete set default" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on delete set default)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_delete, :SET_DEFAULT
end

test "parse basic create table with one column and a foreign key constraint with on delete cascade" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on delete cascade)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_delete, :CASCADE
end

test "parse basic create table with one column and a foreign key constraint with on delete restrict" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on delete restrict)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_delete, :RESTRICT
end

test "parse basic create table with one column and a foreign key constraint with on delete no action" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on delete no action)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_delete, :NO_ACTION
end

test "parse basic create table with one column and a foreign key constraint with on update set null" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on update set null)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_update, :SET_NULL
end

test "parse basic create table with one column and a foreign key constraint with on update set default" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on update set default)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_update, :SET_DEFAULT
end

test "parse basic create table with one column and a foreign key constraint with on update cascade" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on update cascade)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_update, :CASCADE
end

test "parse basic create table with one column and a foreign key constraint with on update restrict" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on update restrict)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_update, :RESTRICT
end

test "parse basic create table with one column and a foreign key constraint with on update no action" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on update no action)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_update, :NO_ACTION
end

test "parse basic create table with one column and a foreign key constraint with on update no action and on delete no action" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) on update no action on delete no action)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_update, :NO_ACTION
	assert_equal node.columns[0].constraints[0].foreign_key_clause.on_delete, :NO_ACTION
end

test "parse basic create table with one column and a foreign key constraint with match" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) match full)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.match_name, "full"
end

test "parse basic create table with one column and a deferred foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) deferrable initially deferred)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.deferred, true
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) deferrable)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.deferred, false
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) not deferrable)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.deferred, false
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) deferrable initially immediate)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.deferred, false
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) not deferrable initially deferred)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.deferred, false
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0 references tb1(c1) not deferrable initially immediate)
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_operator Plume::ForeignKeyColumnConstraint, :===, node.columns[0].constraints[0]
	assert_equal node.columns[0].constraints[0].foreign_key_clause.foreign_table, "tb1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.columns[0], "c1"
	assert_equal node.columns[0].constraints[0].foreign_key_clause.deferred, false
end

test "parse a basic create table with STRICT table option" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0) STRICT
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_equal node.strict, true
	assert_operator Plume::StrictTableOption, :===, node.options[0]
end

test "parse a basic create table with WITHOUT ROWID table option" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0) WITHOUT ROWID
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_equal node.without_row_id, true
	assert_operator Plume::WithoutRowidTableOption, :===, node.options[0]
end

test "parse a basic create table with STRICT and WITHOUT ROWID table options" do
	node = parse_stmt(<<~SQL)
		create table tb0 (c0) STRICT, WITHOUT ROWID
	SQL

	assert_equal node.table_name, "tb0"
	assert_equal node.columns[0].name, "c0"
	assert_equal node.strict, true
	assert_operator Plume::StrictTableOption, :===, node.options[0]
	assert_equal node.without_row_id, true
	assert_operator Plume::WithoutRowidTableOption, :===, node.options[1]
end
