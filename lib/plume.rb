# frozen_string_literal: true

require "plume/version"
require 'set'
require "literal"

module Plume
	extend Literal::Types

	autoload :Lexer, "plume/lexer"
	autoload :Parser, "plume/parser"
	autoload :Token, "plume/ast/token"

	autoload :BinaryExpression, "plume/ast/binary_expression"
	autoload :ParentheticalExpression, "plume/ast/parenthetical_expression"
	autoload :Blob, "plume/ast/blob"
	autoload :CaseCondition, "plume/ast/case_condition"
	autoload :CaseExpression, "plume/ast/case_expression"
	autoload :CastExpression, "plume/ast/cast_expression"
	autoload :CheckColumnConstraint, "plume/ast/check_column_constraint"
	autoload :CheckTableConstraint, "plume/ast/check_table_constraint"
	autoload :CollateColumnConstraint, "plume/ast/collate_column_constraint"
	autoload :CollationExpression, "plume/ast/collation_expression"
	autoload :ColumnConstraint, "plume/ast/column_constraint"
	autoload :ColumnDefinition, "plume/ast/column_definition"
	autoload :ColumnName, "plume/ast/column_name"
	autoload :ColumnType, "plume/ast/column_type"
	autoload :ConflictClause, "plume/ast/conflict_clause"
	autoload :CreateTableStatement, "plume/ast/create_table_statement"
	autoload :CrossJoinOperator, "plume/ast/cross_join_operator"
	autoload :DefaultColumnConstraint, "plume/ast/default_column_constraint"
	autoload :EmptyFunctionArgument, "plume/ast/empty_function_argument"
	autoload :ExceptCompoundOperator, "plume/ast/except_compound_operator"
	autoload :Expression, "plume/ast/expression"
	autoload :ForeignKeyAction, "plume/ast/foreign_key_action"
	autoload :ForeignKeyClause, "plume/ast/foreign_key_clause"
	autoload :ForeignKeyColumnConstraint, "plume/ast/foreign_key_column_constraint"
	autoload :ForeignKeyTableConstraint, "plume/ast/foreign_key_table_constraint"
	autoload :FrameBoundary, "plume/ast/frame_boundary"
	autoload :FrameSpec, "plume/ast/frame_spec"
	autoload :FullJoinOperator, "plume/ast/full_join_operator"
	autoload :FunctionArguments, "plume/ast/function_arguments"
	autoload :FunctionReference, "plume/ast/function_reference"
	autoload :GeneratedAsColumnConstraint, "plume/ast/generated_as_column_constraint"
	autoload :InExpression, "plume/ast/in_expression"
	autoload :IndexedColumn, "plume/ast/indexed_column"
	autoload :InnerJoinOperator, "plume/ast/inner_join_operator"
	autoload :IntersectCompoundOperator, "plume/ast/intersect_compound_operator"
	autoload :JoinOnConstraint, "plume/ast/join_on_constraint"
	autoload :JoinUsingConstraint, "plume/ast/join_using_constraint"
	autoload :LeftJoinOperator, "plume/ast/left_join_operator"
	autoload :LikeExpression, "plume/ast/like_expression"
	autoload :LiteralFalse, "plume/ast/literal_false"
	autoload :LiteralNil, "plume/ast/literal_nil"
	autoload :LiteralValue, "plume/ast/literal_value"
	autoload :MatchClause, "plume/ast/match_clause"
	autoload :NoOpColumnConstraint, "plume/ast/noop_column_constraint"
	autoload :NoOpTableConstraint, "plume/ast/noop_table_constraint"
	autoload :Node, "plume/ast/node"
	autoload :NotInExpression, "plume/ast/not_in_expression"
	autoload :NotLikeExpression, "plume/ast/not_like_expression"
	autoload :NotNullColumnConstraint, "plume/ast/not_null_column_constraint"
	autoload :NullColumnConstraint, "plume/ast/null_column_constraint"
	autoload :OrderingTerm, "plume/ast/ordering_term"
	autoload :OverClause, "plume/ast/over_clause"
	autoload :PrimaryKeyColumnConstraint, "plume/ast/primary_key_column_constraint"
	autoload :PrimaryKeyTableConstraint, "plume/ast/primary_key_table_constraint"
	autoload :RaiseExpression, "plume/ast/raise_expression"
	autoload :ResultColumn, "plume/ast/result_column"
	autoload :RightJoinOperator, "plume/ast/right_join_operator"
	autoload :SelectStatement, "plume/ast/select_statement"
	autoload :SignedExpression, "plume/ast/signed_expression"
	autoload :StarFunctionArgument, "plume/ast/star_function_argument"
	autoload :StarResultColumn, "plume/ast/star_result_column"
	autoload :StrictTableOption, "plume/ast/strict_table_option"
	autoload :TableConstraint, "plume/ast/table_constraint"
	autoload :TableName, "plume/ast/table_name"
	autoload :TableOption, "plume/ast/table_option"
	autoload :TernaryExpression, "plume/ast/ternary_expression"
	autoload :UnaryExpression, "plume/ast/unary_expression"
	autoload :UnionAllCompoundOperator, "plume/ast/union_all_compound_operator"
	autoload :UnionCompoundOperator, "plume/ast/union_compound_operator"
	autoload :UniqueColumnConstraint, "plume/ast/unique_column_constraint"
	autoload :UniqueTableConstraint, "plume/ast/unique_table_constraint"
	autoload :LiteralExpression, "plume/ast/literal_expression"
	autoload :Variable, "plume/ast/variable"
	autoload :WithoutRowidTableOption, "plume/ast/without_rowid_table_option"

	SyntaxError = Class.new(StandardError)

	def self.tokenize(str, with_values: false, skip_spaces: true)
		lex = Lexer.new(str, skip_spaces: skip_spaces)
		[].tap do |tokens|
			while (token = lex.next_token)
				tokens << (with_values ? [token, lex.value] : token)
			end
		end
	end

	def self.parse(sql)
		Parser.new(sql).parse
	end
end
