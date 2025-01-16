# frozen_string_literal: true

test "error when parsing a create table with no columns" do
	error = assert_raises(Plume::Parser::SyntaxError) do
		parse(<<~SQL)
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
	assert_statement(
		<<~SQL,
			create table tb0 (c0)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			]
		)
	)
end

test "parse a basic create table with one column and double-quoted identifiers" do
	assert_statement(
		<<~SQL,
			create table "tb0" ("c0")
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			]
		)
	)
end

test "parse a basic create temp table with one column" do
	assert_statement(
		<<~SQL,
			create temp table tb0 (c0)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			],
			temporary: true
		)
	)
end

test "parse a basic temporary create table with one column" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			],
			temporary: true
		)
	)
end

test "parse a basic create table if not exists with one column" do
	assert_statement(
		<<~SQL,
			create table if not exists tb0 (c0)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			],
			if_not_exists: true,
		)
	)
end

test "parse a basic create temp table if not exists with one column" do
	assert_statement(
		<<~SQL,
			create temp table if not exists tb0 (c0)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			],
			temporary: true,
			if_not_exists: true,
		)
	)
end

test "parse a basic create table with one column with a int type" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0 int)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					type_name: Plume::IntegerType.new(name: "int"),
				),
			],
			temporary: true
		)
	)
end

test "parse a basic create table with one column with a char type" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0 char)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					type_name: Plume::TextType.new(name: "char"),
				),
			],
			temporary: true
		)
	)
end

test "parse a basic create table with one column with a blob type" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0 blob)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					type_name: Plume::BlobType.new(name: "blob"),
				),
			],
			temporary: true
		)
	)
end

test "parse a basic create table with one column with a real type" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0 real)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					type_name: Plume::RealType.new(name: "real"),
				),
			],
			temporary: true
		)
	)
end

test "parse a basic create table with one column with a any type" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0 any)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					type_name: Plume::AnyType.new(name: "any"),
				),
			],
			temporary: true
		)
	)
end

test "parse a basic create table with one column with a constrained type" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0 decimal(4, 6))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					type_name: Plume::AnyType.new(
						name: "decimal",
						constraints: [4, 6],
					),
				),
			],
			temporary: true
		)
	)
end

test "parse basic create table with one column and a primary key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 primary key)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::PrimaryKeyColumnConstraint.new,
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named primary key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' primary key)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::PrimaryKeyColumnConstraint.new(
							name: "name"
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a primary key constraint with options" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 primary key desc on conflict abort autoincrement)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::PrimaryKeyColumnConstraint.new(
							direction: :DESC,
							conflict_clause: :ABORT,
							autoincrement: true,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named primary key constraint with options" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' primary key desc on conflict abort autoincrement)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::PrimaryKeyColumnConstraint.new(
							name: "name",
							direction: :DESC,
							conflict_clause: :ABORT,
							autoincrement: true,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a not null constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 not null)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::NotNullColumnConstraint.new,
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named not null constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' not null)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::NotNullColumnConstraint.new(
							name: "name",
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a not null constraint with options" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 not null on conflict abort)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::NotNullColumnConstraint.new(
							conflict_clause: :ABORT,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named not null constraint with options" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' not null on conflict abort)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::NotNullColumnConstraint.new(
							name: "name",
							conflict_clause: :ABORT,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a unique constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 unique)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::UniqueColumnConstraint.new,
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named unique constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' unique)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::UniqueColumnConstraint.new(
							name: "name",
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a unique constraint with options" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 unique on conflict abort)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::UniqueColumnConstraint.new(
							conflict_clause: :ABORT,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named unique constraint with options" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' unique on conflict abort)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::UniqueColumnConstraint.new(
							name: "name",
							conflict_clause: :ABORT,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a check constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 check (c0 > 0))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::CheckColumnConstraint.new(
							expression: Plume::BinaryExpression.new(
								operator: :ABOVE,
								left: Plume::ColumnReference.new(column_name: "c0"),
								right: 0
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named check constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' check (c0 > 0))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::CheckColumnConstraint.new(
							name: "name",
							expression: Plume::BinaryExpression.new(
								operator: :ABOVE,
								left: Plume::ColumnReference.new(column_name: "c0"),
								right: 0
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a default signed number" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 default 123)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::DefaultColumnConstraint.new(
							value: 123,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named default signed number" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' default 123)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::DefaultColumnConstraint.new(
							name: "name",
							value: 123,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a default literal value" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 default 'foo')
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::DefaultColumnConstraint.new(
							value: "foo",
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named default literal value" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' default 'foo')
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::DefaultColumnConstraint.new(
							name: "name",
							value: "foo",
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a default expression" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 default ('a' || 'b'))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::DefaultColumnConstraint.new(
							value: Plume::BinaryExpression.new(
								operator: :CONCAT,
								left: "a",
								right: "b",
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named default expression" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' default ('a' || 'b'))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::DefaultColumnConstraint.new(
							name: "name",
							value: Plume::BinaryExpression.new(
								operator: :CONCAT,
								left: "a",
								right: "b",
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a collate constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 collate rtrim)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::CollateColumnConstraint.new(
							collation_name: :RTRIM,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named collate constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' collate rtrim)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::CollateColumnConstraint.new(
							name: "name",
							collation_name: :RTRIM,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a generated as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 generated always as (1 + 2))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named generated as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' generated always as (1 + 2))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							name: "name",
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and an as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 as (1 + 2))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' as (1 + 2))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							name: "name",
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a stored generated as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 generated always as (1 + 2) stored)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :STORED,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a stored generated as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' generated always as (1 + 2) stored)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							name: "name",
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :STORED,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a stored as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 as (1 + 2) stored)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :STORED,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named stored as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' as (1 + 2) stored)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							name: "name",
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :STORED,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a virtual generated as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 generated always as (1 + 2) virtual)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :VIRTUAL,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named virtual generated as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' generated always as (1 + 2) virtual)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							name: "name",
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :VIRTUAL,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a virtual as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 as (1 + 2) virtual)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :VIRTUAL,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a virtual as constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' as (1 + 2) virtual)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::GeneratedAsColumnConstraint.new(
							name: "name",
							expression: Plume::BinaryExpression.new(
								operator: :ADD,
								left: 1,
								right: 2,
							),
							type: :VIRTUAL,
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a named foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 constraint 'name' references tb1(c1))
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							name: "name",
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on delete set null" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on delete set null)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_delete: :SET_NULL,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on delete set default" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on delete set default)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_delete: :SET_DEFAULT,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on delete cascade" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on delete cascade)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_delete: :CASCADE,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on delete restrict" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on delete restrict)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_delete: :RESTRICT,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on delete no action" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on delete no action)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_delete: :NO_ACTION,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on update set null" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on update set null)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_update: :SET_NULL,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on update set default" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on update set default)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_update: :SET_DEFAULT,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on update cascade" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on update cascade)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_update: :CASCADE,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on update restrict" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on update restrict)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_update: :RESTRICT,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on update no action" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on update no action)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_update: :NO_ACTION,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with on update no action and on delete no action" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) on update no action on delete no action)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								on_update: :NO_ACTION,
								on_delete: :NO_ACTION,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a foreign key constraint with match" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) match full)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								match_name: "full",
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and a deferred foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) deferrable initially deferred)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								deferred: true,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) deferrable)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								deferred: false,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) not deferrable)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								deferred: false,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) deferrable initially immediate)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								deferred: false,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) not deferrable initially deferred)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								deferred: false,
							)
						),
					]
				),
			],
		)
	)
end

test "parse basic create table with one column and an immediate foreign key constraint" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0 references tb1(c1) not deferrable initially immediate)
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
					constraints: [
						Plume::ForeignKeyColumnConstraint.new(
							foreign_key_clause: Plume::ForeignKeyClause.new(
								foreign_table: "tb1",
								columns: ["c1"],
								deferred: false,
							)
						),
					]
				),
			],
		)
	)
end

test "parse a basic create table with STRICT table option" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0) STRICT
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			],
			strict: true,
		)
	)
end

test "parse a basic create table with WITHOUT ROWID table option" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0) WITHOUT ROWID
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			],
			without_row_id: true,
		)
	)
end

test "parse a basic create table with STRICT and WITHOUT ROWID table options" do
	assert_statement(
		<<~SQL,
			create table tb0 (c0) STRICT, WITHOUT ROWID
		SQL
		Plume::CreateTableStatement.new(
			table_name: "tb0",
			columns: [
				Plume::ColumnDefinition.new(
					name: "c0",
				),
			],
			strict: true,
			without_row_id: true,
		)
	)
end
