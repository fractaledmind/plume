# frozen_string_literal: true

module Plume
	extend Literal::Types

	NIL = Object.new
	FALSE = Object.new

	class Node < Literal::Data; end

	Direction = _Union(:ASC, :DESC)
	ConflictClause = _Union(:ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE)
	CollationName = _Union(:BINARY, :RTRIM, :NOCASE)

	class Blob < Literal::Data
		prop :blob, _Union(
			IO,
			proc { |it| StringIO === it if defined?(StringIO) }
		)
	end

	LiteralValue = _Union(
		nil,
		true,
		false,
		:CURRENT_TIME,
		:CURRENT_DATE,
		:CURRENT_TIMESTAMP,
		:*,
		Numeric,
		String,
		Blob
	)

	SignedNumber = Numeric

	class ColumnConstraint < Node
		# abstract
	end

	class Type < Node
		prop :name, String

		prop :constraints, _Nilable(
			_Constraint(
				_Array(SignedNumber),
				size: 0..2
			)
		)
	end

	class IntegerType < Type; end
	class RealType < Type; end
	class TextType < Type; end
	class BlobType < Type; end
	class AnyType < Type; end

	Expression = _Union(
		LiteralValue,
		_Deferred {
			_Union(
				Identifier,
				ColumnReference,
				UnaryExpression,
				BinaryExpression,
				CastExpression,
				TernaryExpression,
				LikeExpression,
				InExpression,
				NotInExpression,
			)
		},
	)

	class PrimaryKeyColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :direction, _Nilable(Direction)
		prop :conflict_clause, _Nilable(ConflictClause)
		prop :autoincrement, _Nilable(_Boolean)
	end

	class NotNullColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :conflict_clause, _Nilable(ConflictClause)
	end

	class UniqueColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :conflict_clause, _Nilable(ConflictClause)
	end

	class CheckColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :expression, Expression
	end

	class DefaultColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :value, _Union(LiteralValue, SignedNumber, Expression)
	end

	class CollateColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :collation_name, CollationName
	end

	class GeneratedAsColumnConstraint < ColumnConstraint
		Type = _Union(:STORED, :VIRTUAL)

		prop :name, _Nilable(String)
		prop :expression, Expression
		prop :type, _Nilable(Type)
	end

	class ForeignKeyClause < Node
		Action = _Union(:SET_NULL, :SET_DEFAULT, :CASCADE, :RESTRICT, :NO_ACTION)

		prop :foreign_table, String
		prop :columns, _Nilable(_Array(String))
		prop :on_delete, _Nilable(Action)
		prop :on_update, _Nilable(Action)
		prop :match_name, _Nilable(String)
		prop :deferred, _Nilable(_Boolean)
	end

	class ForeignKeyColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :foreign_key_clause, ForeignKeyClause
	end

	class ColumnDefinition < Node
		prop :name, String
		prop :type_name, _Nilable(Type)
		prop :constraints, _Nilable(_Array(ColumnConstraint))
	end

	class Variable < Node
		prop :name, String
	end

	class ColumnReference < Node
		prop :schema_name, _Nilable(String)
		prop :table_name, _Nilable(String)
		prop :column_name, String
	end

	class TableReference < Node
		prop :schema_name, _Nilable(String)
		prop :table_name, String
	end

	class UnaryExpression < Node
		prop :operator, _Union(:INVERT, :NEGATE, :IDENTITY, :NOT, :IS_NULL, :NOT_NULL)
		prop :operand, Expression
	end

	class BinaryExpression < Node
		prop :operator, _Union(
			:ABOVE,
			:ADD,
			:ALL,
			:ANY,
			:ATLEAST,
			:ATMOST,
			:BELOW,
			:BIT_AND,
			:BIT_LSHIFT,
			:BIT_OR,
			:BIT_RSHIFT,
			:CONCAT,
			:DIVIDE,
			:EQUALS,
			:EXTRACT,
			:GLOB,
			:IS,
			:IS_NOT,
			:MATCH,
			:MODULO,
			:MULTIPLY,
			:NOT_EQUALS,
			:NOT_GLOB,
			:NOT_MATCH,
			:NOT_REGEXP,
			:REGEXP,
			:RETRIEVE,
			:SUB,
		)

		prop :left, Expression
		prop :right, Expression
	end

	class LikeExpression < Node
		prop :left, Expression
		prop :right, Expression
		prop :escape, _Nilable(Expression)
	end

	class NotLikeExpression < LikeExpression
	end

	class CaseCondition < Node
		prop :predicate, Expression
		prop :consequence, Expression
	end

	class CaseExpression < Node
		prop :predicate, _Nilable(Expression)
		prop :conditions, _Array(CaseCondition)
		prop :else_clause, _Nilable(Expression)
	end

	class Identifier < Node
		prop :value, String
	end

	class CastExpression < Node
		prop :expression, Expression
		prop :as, Type
	end

	class TernaryExpression < Node
		prop :operator, _Union(:BETWEEN, :NOT_BETWEEN)
		prop :left, Expression
		prop :middle, Expression
		prop :right, Expression
	end

	class SelectStatement < Node
	end

	class FunctionArguments < Node
		prop :distinct, _Nilable(_Boolean)
		prop :expressions, _Array(Expression)
		prop :order_by, _Nilable(_Array(Expression))
	end

	class StarFunctionArgument < Node; end
	class EmptyFunctionArgument < Node; end

	class FunctionReference < Node
		prop :schema_name, _Nilable(String)
		prop :function_name, _Union(String, Symbol)
		prop :arguments, _Union(FunctionArguments, StarFunctionArgument, EmptyFunctionArgument)
		prop :filter_clause, _Nilable(Expression)
		prop :over_clause, _Nilable(Expression)
	end

	class FrameSpec < Node
		prop :type, _Union(:RANGE, :ROWS, :GROUPS)
		prop :starting_boundary, _Any
		prop :ending_boundary, _Nilable(_Any)
		prop :exclude, _Nilable(_Union(:NO_OTHERS, :CURRENT_ROW, :GROUP, :TIES))
	end

	class FrameBoundary < Node
		prop :type, _Union(:PRECEDING, :FOLLOWING, :CURRENT_ROW)
		prop :value, _Union(Expression, :UNBOUNDED)
	end

	class OrderingTerm < Node
		prop :expression, Expression
		prop :collation, _Nilable(String)
		prop :direction, _Nilable(_Union(:ASC, :DESC))
		prop :nulls, _Nilable(_Union(:FIRST, :LAST))
	end

	class OverClause < Node
		prop :window_name, _Nilable(String)
		prop :base_window_name, _Nilable(String)
		prop :partition_by, _Nilable(_Array(Expression))
		prop :order_by, _Nilable(_Array(OrderingTerm))
		prop :frame, _Nilable(FrameSpec)
	end

	class InExpression < Node
		prop :member, Expression
		prop :collection, _Union(
			SelectStatement,
			TableReference,
			FunctionReference,
			_Array(Expression),
		)
	end

	class NotInExpression < InExpression
	end

	# - `schema_name` → `_Nilable(String)`
	# - `table_name` → `String`
	# - `select_statement` → `_Nilable(SelectStatement)`
	# - `columns` → `_Array(ColumnDefinition)`
	# - `strict` → `_Nilable(_Boolean)`
	# - `temporary` → `_Nilable(_Boolean)`
	# - `if_not_exists` → `_Nilable(_Boolean)`
	# - `without_row_id` → `_Nilable(_Boolean)`
	# - `constraints` → `_Array(TableConstraint)`
	#
	# ```
	# ◯─▶{ CREATE }┬───────▶──────┬▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
	#              ├▶{ TEMP }─────┤          │                             │
	#              └▶{ TEMPORARY }┘          │                             │
	# ┌─────────────────────◀────────────────┴──────────────────◀──────────┘
	# ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }┬───────▶{ AS }─▶[ select-stmt ]───▶─────┐
	# └────────▶────────────────┘               │                                        │
	# ┌────────────────────◀────────────────────┘                     ┌────────▶─────────┼─▶◯
	# └▶{ ( }─┬▶[ column-def ]─┬▶┬─────────────────────────────┬▶{ ) }┴▶[ table-options ]┘
	#         └─────{ , }◀─────┘ └[ table-constraint ]◀─{ , }◀─┘
	# ```
	#
	# **[SQLite Docs](https://www.sqlite.org/lang_createtable.html)**
	#
	# ```sql
	# create table tb0 (c0 primary key desc on conflict abort autoincrement)
	# ```
	class CreateTableStatement < Node
		prop :schema_name, _Nilable(String)
		prop :table_name, String
		# prop :select_statement, _Nilable(SelectStatement)
		prop :columns, _Array(ColumnDefinition)
		prop :strict, _Nilable(_Boolean)
		prop :temporary, _Nilable(_Boolean)
		prop :if_not_exists, _Nilable(_Boolean)
		prop :without_row_id, _Nilable(_Boolean)
		# prop :constraints, _Array(TableConstraint)

		def after_initialize
			raise ArgumentError unless (!!@select_statement ^ @columns.any?)
			raise ArgumentError if @select_statement && (@strict || @without_row_id)
		end
	end
end
