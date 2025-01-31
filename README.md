# Plume

<img src="/assets/logo.svg" width="100" alt="Plume logo: a blue feather quill pen" align="right" />

Plume is a Ruby library for working with SQLite elegantly. Presently, this means that it provides a pure Ruby implementation of SQLite's lexer/tokenizer as well as a 100% compatible parser. This is useful for introspecting the structure of SQL queries, and for building tools that work with SQL queries.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add plume
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install plume
```

## Usage

Parse a SQL query with the `Plume::Parser` class:

> [!NOTE]
> The parser is still work in progress. Only `CREATE TABLE` statements are supported at the moment.

```ruby
sql = <<~SQL
	CREATE TEMP TABLE IF NOT EXISTS `schema0`."tb0" (
		c0 INTEGER PRIMARY KEY DESC ON CONFLICT ABORT AUTOINCREMENT,
		c1 INT NOT NULL ON CONFLICT ROLLBACK,
		c2 TEXT UNIQUE ON CONFLICT IGNORE,
		c3 BLOB CHECK (c3 > 0),
		c4 REAL DEFAULT (1.1 * 2.2),
		c5 ANY COLLATE RTRIM,
		c6 DECIMAL(4, 6) GENERATED ALWAYS AS (1.1 + 2.2) STORED,
		c7 REFERENCES tb1(c1) ON DELETE SET NULL ON UPDATE CASCADE MATCH FULL DEFERRABLE INITIALLY DEFERRED,
		PRIMARY KEY (c0, c1 AUTOINCREMENT) ON CONFLICT ABORT,
		UNIQUE (c0, c1) ON CONFLICT ROLLBACK
		CHECK (c0 > 0)
		FOREIGN KEY (c0) REFERENCES tb1(c1) ON DELETE CASCADE ON UPDATE RESTRICT MATCH FULL DEFERRABLE INITIALLY DEFERRED
	) WITHOUT ROWID;
SQL
ast = Plume::Parser.new(sql).parse.first

# =>
# #<Plume::CreateTableStatement:0x000000011ce3e0a0
#  @columns=
#   [#<Plume::ColumnDefinition:0x000000011ca30828
#     @constraints=
#      [#<Plume::PrimaryKeyColumnConstraint:0x000000011ca34950 @autoincrement=true, @direction=:DESC, @name=nil, @on_conflict=:ABORT>],
#     @name="c0",
#     @type=#<Plume::IntegerType:0x000000011ca3faf8 @constraints=nil, @name="INTEGER">>,
#    #<Plume::ColumnDefinition:0x000000011c857a60
#     @constraints=[#<Plume::NotNullColumnConstraint:0x000000011c8586b8 @name=nil, @on_conflict=:ROLLBACK>],
#     @name="c1",
#     @type=#<Plume::IntegerType:0x000000011c85e978 @constraints=nil, @name="INT">>,
#    #<Plume::ColumnDefinition:0x000000011bf68e68
#     @constraints=[#<Plume::UniqueColumnConstraint:0x000000011bf693e0 @name=nil, @on_conflict=:IGNORE>],
#     @name="c2",
#     @type=#<Plume::TextType:0x000000011c854478 @constraints=nil, @name="TEXT">>,
#    #<Plume::ColumnDefinition:0x000000011ce14bd8
#     @constraints=
#      [#<Plume::CheckColumnConstraint:0x000000011cb73988
#        @expression=
#         #<Plume::BinaryExpression:0x000000011cb761b0
#          @left=#<Plume::ColumnReference:0x000000011cb7dd70 @column_name="c3", @schema_name=nil, @table_name=nil>,
#          @operator=:ABOVE,
#          @right=0>,
#        @name=nil>],
#     @name="c3",
#     @type=#<Plume::BlobType:0x000000011bf67540 @constraints=nil, @name="BLOB">>,
#    #<Plume::ColumnDefinition:0x000000011ce10dd0
#     @constraints=
#      [#<Plume::DefaultColumnConstraint:0x000000011ce11348
#        @name=nil,
#        @value=#<Plume::BinaryExpression:0x000000011ce13bc0 @left=1.1, @operator=:MULTIPLY, @right=2.2>>],
#     @name="c4",
#     @type=#<Plume::RealType:0x000000011ce13ff8 @constraints=nil, @name="REAL">>,
#    #<Plume::ColumnDefinition:0x000000011ccbd258
#     @constraints=[#<Plume::CollateColumnConstraint:0x000000011ccbd7d0 @collation_name=:RTRIM, @name=nil>],
#     @name="c5",
#     @type=#<Plume::AnyType:0x000000011ce10218 @constraints=nil, @name="ANY">>,
#    #<Plume::ColumnDefinition:0x000000011ccb86e0
#     @constraints=
#      [#<Plume::GeneratedAsColumnConstraint:0x000000011ccb8c58
#        @expression=#<Plume::BinaryExpression:0x000000011ccbc588 @left=1.1, @operator=:ADD, @right=2.2>,
#        @name=nil,
#        @type=:STORED>],
#     @name="c6",
#     @type=#<Plume::AnyType:0x000000011ccbcb00 @constraints=[4, 6], @name="DECIMAL">>,
#    #<Plume::ColumnDefinition:0x000000011cabbd88
#     @constraints=
#      [#<Plume::ForeignKeyColumnConstraint:0x000000011cabc5f8
#        @foreign_key_clause=
#         #<Plume::ForeignKeyClause:0x000000011ccb0620
#          @columns=["c1"],
#          @deferred=true,
#          @foreign_table="tb1",
#          @match_name="FULL",
#          @on_delete=:SET_NULL,
#          @on_update=:CASCADE>,
#        @name=nil>],
#     @name="c7",
#     @type=nil>],
#  @constraints=
#   [#<Plume::PrimaryKeyTableConstraint:0x000000011bf0cca8
#     @autoincrement=true,
#     @columns=
#      [#<Plume::IndexedColumn:0x000000011cab67e8
#        @collation=nil,
#        @column=#<Plume::ColumnReference:0x000000011cabb608 @column_name="c0", @schema_name=nil, @table_name=nil>,
#        @direction=nil,
#        @expression=nil>,
#       #<Plume::IndexedColumn:0x000000011be0d258
#        @collation=nil,
#        @column=#<Plume::ColumnReference:0x000000011cab6630 @column_name="c1", @schema_name=nil, @table_name=nil>,
#        @direction=nil,
#        @expression=nil>],
#     @name=nil,
#     @on_conflict=:ABORT>,
#    #<Plume::UniqueTableConstraint:0x000000011beabef8
#     @columns=
#      [#<Plume::IndexedColumn:0x000000011be08208
#        @collation=nil,
#        @column=#<Plume::ColumnReference:0x000000011bf0c190 @column_name="c0", @schema_name=nil, @table_name=nil>,
#        @direction=nil,
#        @expression=nil>,
#       #<Plume::IndexedColumn:0x000000011be08168
#        @collation=nil,
#        @column=#<Plume::ColumnReference:0x000000011bf0bf38 @column_name="c1", @schema_name=nil, @table_name=nil>,
#        @direction=nil,
#        @expression=nil>],
#     @name=nil,
#     @on_conflict=:ROLLBACK>,
#    #<Plume::CheckTableConstraint:0x000000011be8df20
#     @expression=
#      #<Plume::BinaryExpression:0x000000011bea8f28
#       @left=#<Plume::ColumnReference:0x000000011bea9130 @column_name="c0", @schema_name=nil, @table_name=nil>,
#       @operator=:ABOVE,
#       @right=0>,
#     @name=nil>,
#    #<Plume::ForeignKeyTableConstraint:0x000000011be804b0
#     @columns=
#      [#<Plume::IndexedColumn:0x000000011be02da8
#        @collation=nil,
#        @column=#<Plume::ColumnReference:0x000000011be8d818 @column_name="c0", @schema_name=nil, @table_name=nil>,
#        @direction=nil,
#        @expression=nil>],
#     @foreign_key_clause=
#      #<Plume::ForeignKeyClause:0x000000011be02cb8
#       @columns=["c1"],
#       @deferred=true,
#       @foreign_table="tb1",
#       @match_name="FULL",
#       @on_delete=:CASCADE,
#       @on_update=:RESTRICT>,
#     @name=nil>],
#  @if_not_exists=true,
#  @options=[#<Plume::WithoutRowidTableOption:0x0000000100a1a9e0>],
#  @schema_name="schema0",
#  @select_statement=nil,
#  @strict=nil,
#  @table_name="tb0",
#  @temporary=true,
#  @without_row_id=true>
```

Tokenize a SQL query with the `Plume::Lexer` class:

```ruby
lexer = Plume::Lexer.new("SELECT * FROM users WHERE id = 1")
tokens = lexer.tokenize
# =>
# [Plume::TK::SELECT["SELECT"],
#  Plume::TK::SPACE[" "],
#  Plume::TK::STAR["*"],
#  Plume::TK::SPACE[" "],
#  Plume::TK::FROM["FROM"],
#  Plume::TK::SPACE[" "],
#  Plume::TK::ID["users"],
#  Plume::TK::SPACE[" "],
#  Plume::TK::WHERE["WHERE"],
#  Plume::TK::SPACE[" "],
#  Plume::TK::ID["id"],
#  Plume::TK::SPACE[" "],
#  Plume::TK::EQ["="],
#  Plume::TK::SPACE[" "],
#  Plume::TK::INTEGER["1"]]
```

SQLite works with a grammar of _167_ token types, _136_ of which are keywords. The remaining _31_ are punctuation, operators, and literals.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fractaledmind/plume. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/fractaledmind/plume/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Plume project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fractaledmind/plume/blob/main/CODE_OF_CONDUCT.md).
