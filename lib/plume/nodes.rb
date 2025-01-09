# frozen_string_literal: true

module Plume
	extend Literal::Types

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
				UnaryExpression,
				BinaryExpression,
				IdentifierExpression,
				CastExpression
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

	class UnaryExpression < Node
		prop :operator, _Union(:INVERT, :NEGATE, :IDENTITY)
		prop :operand, Expression
	end

	class BinaryExpression < Node
		prop :operator, _Union(
			:CONCAT,
			:EXTRACT,
			:RETRIEVE,
			:MULTIPLY,
			:DIVIDE,
			:MODULO,
			:ADD,
			:SUB,
			:BIT_AND,
			:BIT_OR,
			:BIT_LSHIFT,
			:BIT_RSHIFT,
			:BELOW,
			:ABOVE,
			:ATMOST,
			:ATLEAST,
			:EQUALS,
			:NOT_EQUALS,
			:IS,
			:IS_NOT,
		)

		prop :left, Expression
		prop :right, Expression
	end

	class IdentifierExpression < Node
		prop :value, String
	end

	class CastExpression < Node
		prop :expression, Expression
		prop :as, Type
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
