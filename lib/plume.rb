# frozen_string_literal: true

require "set"
require "plume/version"
require "plume/lexer"
require "plume/ref"
require "plume/parser"
require "literal"
require "plume/create_table_statement"
require "plume/expression"
require "plume/generator"

module Plume
	extend Literal::Types

	autoload :AnyType, "plume/ast/any_type"
	autoload :BinaryExpression, "plume/ast/binary_expression"
	autoload :Blob, "plume/ast/blob"
	autoload :BlobType, "plume/ast/blob_type"
	autoload :CaseCondition, "plume/ast/case_condition"
	autoload :CaseExpression, "plume/ast/case_expression"
	autoload :CastExpression, "plume/ast/cast_expression"
	autoload :CheckColumnConstraint, "plume/ast/check_column_constraint"
	autoload :CollateColumnConstraint, "plume/ast/collate_column_constraint"
	autoload :CollationName, "plume/ast/collation_name"
	autoload :ColumnConstraint, "plume/ast/column_constraint"
	autoload :ColumnDefinition, "plume/ast/column_definition"
	autoload :ColumnReference, "plume/ast/column_reference"
	autoload :ConflictClause, "plume/ast/conflict_clause"
	autoload :CreateTableStatement, "plume/ast/create_table_statement"
	autoload :DefaultColumnConstraint, "plume/ast/default_column_constraint"
	autoload :Direction, "plume/ast/direction"
	autoload :EmptyFunctionArgument, "plume/ast/empty_function_argument"
	autoload :Expression, "plume/ast/expression"
	autoload :ForeignKeyClause, "plume/ast/foreign_key_clause"
	autoload :ForeignKeyColumnConstraint, "plume/ast/foreign_key_column_constraint"
	autoload :FrameBoundary, "plume/ast/frame_boundary"
	autoload :FrameSpec, "plume/ast/frame_spec"
	autoload :FunctionArguments, "plume/ast/function_arguments"
	autoload :FunctionReference, "plume/ast/function_reference"
	autoload :GeneratedAsColumnConstraint, "plume/ast/generated_as_column_constraint"
	autoload :InExpression, "plume/ast/in_expression"
	autoload :IntegerType, "plume/ast/integer_type"
	autoload :LikeExpression, "plume/ast/like_expression"
	autoload :LiteralFalse, "plume/ast/literal_false"
	autoload :LiteralNil, "plume/ast/literal_nil"
	autoload :LiteralValue, "plume/ast/literal_value"
	autoload :Node, "plume/ast/node"
	autoload :NotInExpression, "plume/ast/not_in_expression"
	autoload :NotLikeExpression, "plume/ast/not_like_expression"
	autoload :NotNullColumnConstraint, "plume/ast/not_null_column_constraint"
	autoload :OrderingTerm, "plume/ast/ordering_term"
	autoload :OverClause, "plume/ast/over_clause"
	autoload :PrimaryKeyColumnConstraint, "plume/ast/primary_key_column_constraint"
	autoload :RealType, "plume/ast/real_type"
	autoload :SelectStatement, "plume/ast/select_statement"
	autoload :SignedNumber, "plume/ast/signed_number"
	autoload :StarFunctionArgument, "plume/ast/star_function_argument"
	autoload :TableReference, "plume/ast/table_reference"
	autoload :TernaryExpression, "plume/ast/ternary_expression"
	autoload :TextType, "plume/ast/text_type"
	autoload :Type, "plume/ast/type"
	autoload :UnaryExpression, "plume/ast/unary_expression"
	autoload :UniqueColumnConstraint, "plume/ast/unique_column_constraint"
	autoload :Variable, "plume/ast/variable"
	autoload :RaiseExpression, "plume/ast/raise_expression"
	autoload :CollationExpression, "plume/ast/collation_expression"

	def self.tokenize(str)
		Lexer.new(str).tokenize
	end

	def self.parse(sql)
		Parser.new(sql).parse
	end
end
