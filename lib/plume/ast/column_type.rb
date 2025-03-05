# frozen_string_literal: true

module Plume
	class ColumnType < Node
		required_token :text_span,
			reader: :text,
			default: -> { text_span_val }

		inspectable def affinity
			# rules found at: https://www.sqlite.org/datatype3.html#determination_of_column_affinity
			case text
			when /INT/i							then	:INTEGER
			when /CHAR|CLOB|TEXT/i	then	:TEXT
			when /BLOB/i						then	:BLOB
			when /REAL|FLOA|DOUB/i	then	:REAL
			else													:ANY
			end
		end
	end
end
