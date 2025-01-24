# frozen_string_literal: true

module Plume
	class IndexedColumn < Node
		required_node :column, ColumnReference

		optional_node :expression, Expression
		optional_node :collation, String
		optional_node :direction, Direction
	end
end
