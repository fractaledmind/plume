# frozen_string_literal: true

module Plume
	ConflictClause = _Union(
		:ROLLBACK,
		:ABORT,
		:FAIL,
		:IGNORE,
		:REPLACE
	)
end
