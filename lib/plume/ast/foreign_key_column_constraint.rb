# frozen_string_literal: true

module Plume
	class ForeignKeyColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :foreign_key_clause, ForeignKeyClause
	end
end
