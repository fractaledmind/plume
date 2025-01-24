# frozen_string_literal: true

module Plume
	class NullColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		optional_token :conflict_clause

		inspectable def on_conflict = conflict_clause_src&.sub(/ON CONFLICT /i, "")&.to_sym&.upcase
	end
end
