# Plume

[![Gem Version](https://badge.fury.io/rb/plume.svg)](https://rubygems.org/gems/plume)
[![Gem Downloads](https://img.shields.io/gem/dt/plume)](https://rubygems.org/gems/plume)
![Tests](https://github.com/fractaledmind/plume/actions/workflows/main.yml/badge.svg)
![Coverage](https://img.shields.io/badge/code%20coverage-96%25-success)
[![Sponsors](https://img.shields.io/github/sponsors/fractaledmind?color=eb4aaa&logo=GitHub%20Sponsors)](https://github.com/sponsors/fractaledmind)
[![Twitter Follow](https://img.shields.io/twitter/url?label=%40fractaledmind&style=social&url=https%3A%2F%2Ftwitter.com%2Ffractaledmind)](https://twitter.com/fractaledmind)

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
    c3 BLOB CHECK (    c3 > 0),
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
ast = Plume.parse(sql)
# => Plume::CreateTableStatement(...)
```

<details>
  <summary>(click to see full AST)</summary>

```ruby
Plume::CreateTableStatement(
  temporary = true,
  if_not_exists = true,
  table = Plume::TableName(
    schema = "schema0",
    table = "tb0",
  ),
  columns = [
    Plume::ColumnDefinition(
      name = "c0",
      type = Plume::ColumnType(
        text = "INTEGER",
        affinity = :INTEGER,
      ),
      constraints = [
        Plume::PrimaryKeyColumnConstraint(...),
      ],
    ),
    Plume::ColumnDefinition(
      name = "c1",
      type = Plume::ColumnType(
        text = "INT",
        affinity = :INTEGER,
      ),
      constraints = [
        Plume::NotNullColumnConstraint(...),
      ],
    ),
    Plume::ColumnDefinition(
      name = "c2",
      type = Plume::ColumnType(
        text = "TEXT",
        affinity = :TEXT,
      ),
      constraints = [
        Plume::UniqueColumnConstraint(...),
      ],
    ),
    Plume::ColumnDefinition(
      name = "c3",
      type = Plume::ColumnType(
        text = "BLOB",
        affinity = :BLOB,
      ),
      constraints = [
        Plume::CheckColumnConstraint(...),
      ],
    ),
    Plume::ColumnDefinition(
      name = "c4",
      type = Plume::ColumnType(
        text = "REAL",
        affinity = :REAL,
      ),
      constraints = [
        Plume::DefaultColumnConstraint(...),
      ],
    ),
    Plume::ColumnDefinition(
      name = "c5",
      type = Plume::ColumnType(
        text = "ANY",
        affinity = :ANY,
      ),
      constraints = [
        Plume::CollateColumnConstraint(...),
      ],
    ),
    Plume::ColumnDefinition(
      name = "c6",
      type = Plume::ColumnType(
        text = "DECIMAL(4, 6)",
        affinity = :ANY,
      ),
      constraints = [
        Plume::GeneratedAsColumnConstraint(...),
      ],
    ),
    Plume::ColumnDefinition(
      name = "c7",
      constraints = [
        Plume::ForeignKeyColumnConstraint(...),
      ],
    ),
  ],
  constraints = [
    Plume::PrimaryKeyTableConstraint(
      autoincrement = true,
      columns = [
        Plume::IndexedColumn(...),
        Plume::IndexedColumn(...),
      ],
      conflict_clause = Plume::ConflictClause(resolution = :ABORT),
    ),
    Plume::UniqueTableConstraint(
      columns = [
        Plume::IndexedColumn(...),
        Plume::IndexedColumn(...),
      ],
      conflict_clause = Plume::ConflictClause(resolution = :ROLLBACK),
    ),
    Plume::CheckTableConstraint(
      expression = Plume::BinaryExpression(
        operator = :ABOVE,
        left = Plume::ColumnName(...),
        right = Plume::LiteralExpression(...),
      ),
    ),
    Plume::ForeignKeyTableConstraint(
      columns = [Plume::IndexedColumn(...)],
      foreign_key_clause = Plume::ForeignKeyClause(
        table = "tb1",
        deferred = true,
        columns = [...],
        actions = [...],
        match_clauses = [...],
      ),
    ),
  ],
  options = [
    Plume::WithoutRowidTableOption(),
  ],
  select_statement = Object(),
  strict = false,
  without_row_id = true,
)
```
</details>


Tokenize a SQL query with the `Plume::Lexer` class:

```ruby
tokens = Plume.tokenize("SELECT * FROM users WHERE id = 1")
# => [:SELECT, :STAR, :FROM, :ID, :WHERE, :ID, :EQ, :INTEGER]
```

SQLite works with a grammar of _167_ token types, _136_ of which are keywords. The remaining _31_ are punctuation, operators, and literals.

## Roadmap

- [x] `expression`
- [ ] `alter_table_stmt`
- [ ] `analyze_stmt`
- [ ] `attach_stmt`
- [ ] `begin_stmt`
- [ ] `commit_stmt`
- [x] `create_table_stmt`
- [ ] `create_index_stmt`
- [ ] `create_trigger_stmt`
- [ ] `create_view_stmt`
- [ ] `create_virtual_table_stmt`
- [ ] `delete_stmt`
- [ ] `detach_stmt`
- [ ] `drop_index_stmt`
- [ ] `drop_table_stmt`
- [ ] `drop_trigger_stmt`
- [ ] `drop_view_stmt`
- [ ] `insert_stmt`
- [ ] `pragma_stmt`
- [ ] `reindex_stmt`
- [ ] `release_stmt`
- [ ] `rollback_stmt`
- [ ] `savepoint_stmt`
- [ ] `select_stmt`
- [ ] `update_stmt`
- [ ] `vacuum_stmt`
- [ ] `with_stmt`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fractaledmind/plume. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/fractaledmind/plume/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Plume project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fractaledmind/plume/blob/main/CODE_OF_CONDUCT.md).
