# frozen_string_literal: true

module Plume
	class PrimaryKeyColumnConstraint < ColumnConstraint
		optional_node :direction, Direction

		optional_token :name, inspect: true
		optional_token :conflict_clause, inspect: true
		optional_token :autoincrement_kw

		inspectable def autoincrement = !!@autoincrement_kw
	end
end
