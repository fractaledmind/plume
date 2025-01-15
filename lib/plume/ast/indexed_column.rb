# frozen_string_literal: true

module Plume
	class IndexedColumn < Node
		prop :column, ColumnReference
		prop :expression, _Nilable(Expression)
		prop :collation, _Nilable(String)
		prop :direction, _Nilable(Direction)
	end
end
