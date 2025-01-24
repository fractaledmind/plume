# frozen_string_literal: true

module Plume
	class ForeignKeyColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		prop :foreign_key_clause, ForeignKeyClause
	end
end
