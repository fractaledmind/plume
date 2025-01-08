# frozen_string_literal: true

module Plume
	class BaseNode
		def self.parse(sql)
			Parser.parse(sql, as: self.class)
		end
	end

	class CreateTableStatement
		def self.deserialize(data)
			new(**data)
		end

		def self.parse(sql)
			Parser.parse_as_create_table_statement(sql)
		end

		def to_h
			serialize
		end

		def to_s
		end

		def serialize(terse: false)
		end
	end
end
