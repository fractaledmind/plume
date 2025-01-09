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
		"  Expected one of: STRING, ID, INDEXED, JOIN_KW",
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

test "parse a basic create table with one column with a type" do
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
