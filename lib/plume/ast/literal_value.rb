# frozen_string_literal: true

module Plume
	LiteralValue = _Union(
		nil,
		true,
		false,
		:CURRENT_TIME,
		:CURRENT_DATE,
		:CURRENT_TIMESTAMP,
		:*,
		Numeric,
		String,
		Blob,
		LiteralNil,
		LiteralFalse,
	)
end
