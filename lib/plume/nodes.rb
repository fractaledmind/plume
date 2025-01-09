# frozen_string_literal: true

module Plume
	extend Literal::Types

	class Node < Literal::Data; end

	Direction = _Union(:ASC, :DESC)
	ConflictClause = _Union(:ROLLBACK, :ABORT, :FAIL, :IGNORE, :REPLACE)
	CollationName = _Union(:BINARY, :RTRIM, :NOCASE)

	# TODO: Make this rich
	Expression = _Any
	LiteralValue = _Any
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

	# ◯─▶{ CREATE }┬───────▶──────┬▶{ TABLE }┬▶{ IF }─▶{ NOT }─▶{ EXISTS }─┐
	#              ├▶{ TEMP }─────┤          │                             │
	#              └▶{ TEMPORARY }┘          │                             │
	# ┌─────────────────────◀────────────────┴──────────────────◀──────────┘
	# ├─▶{ schema-name }─▶{ . }─┬▶{ table-name }┬───────▶{ AS }─▶[ select-stmt ]───▶─────┐
	# └────────▶────────────────┘               │                                        │
	# ┌────────────────────◀────────────────────┘                     ┌────────▶─────────┼─▶◯
	# └▶{ ( }─┬▶[ column-def ]─┬▶┬─────────────────────────────┬▶{ ) }┴▶[ table-options ]┘
	#         └─────{ , }◀─────┘ └[ table-constraint ]◀─{ , }◀─┘
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
