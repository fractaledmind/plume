# frozen_string_literal: true

module Plume
	class PrimaryKeyColumnConstraint < ColumnConstraint
		optional_node :direction, Direction

		optional_token :name, inspect: true
		optional_token :conflict_clause
		optional_token :autoincrement_kw

		inspectable def autoincrement = !!@autoincrement_kw
		inspectable def on_conflict = conflict_clause_src&.sub(/ON CONFLICT /i, "")&.to_sym&.upcase
	end
end
