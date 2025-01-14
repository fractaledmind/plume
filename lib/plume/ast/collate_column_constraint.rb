# frozen_string_literal: true

module Plume
	class CollateColumnConstraint < ColumnConstraint
		prop :name, _Nilable(String)
		prop :collation_name, CollationName
	end
end
