# frozen_string_literal: true

module Plume
	CollationName = _Union(
		:BINARY,
		:RTRIM,
		:NOCASE
	)
end
