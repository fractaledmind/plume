# frozen_string_literal: true

module Plume
	class ForeignKeyColumnConstraint < ColumnConstraint
		required_node :foreign_key_clause, ForeignKeyClause

		optional_token :name, inspect: true
	end
end
