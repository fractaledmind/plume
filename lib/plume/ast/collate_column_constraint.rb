# frozen_string_literal: true

module Plume
	class CollateColumnConstraint < ColumnConstraint
		optional_token :name, inspect: true
		prop :collation_name, Symbol
	end
end
