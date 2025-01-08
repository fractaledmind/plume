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
		{
			CREATE_TABLE: {
				Plume::TableRef["c0"] => [
					{
						Plume::ColumnRef["c0"] => [
							nil, []
						]
					},
				],
			}
		}
	)
end

test "parse a basic create temp table with one column" do
	assert_statement(
		<<~SQL,
			create temp table tb0 (c0)
		SQL
		{
			CREATE_TABLE: {
				Plume::TableRef["c0"] => [
					{
						Plume::ColumnRef["c0"] => [
							nil, []
						]
					},
				],
				TEMPORARY: true,
			}
		}
	)
end

test "parse a basic temporary create table with one column" do
	assert_statement(
		<<~SQL,
			create temporary table tb0 (c0)
		SQL
		{
			CREATE_TABLE: {
				Plume::TableRef["c0"] => [
					{
						Plume::ColumnRef["c0"] => [
							nil, []
						]
					},
				],
				TEMPORARY: true,
			}
		}
	)
end
