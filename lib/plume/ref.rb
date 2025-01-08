# frozen_string_literal: true

module Plume
	class ColumnRef
		attr_reader :parts, :schema, :table, :column

		def self.[](*args, **kwargs)
			if kwargs.any?
				new(**kwargs)
			elsif args.any?
				case args.size
				when 1
					new(column: args.first)
				when 2
					new(table: args.first, column: args.last)
				when 3
					new(schema: args.first, table: args[1], column: args.last)
				else
					raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1..3)"
				end
			end
		end

		def initialize(schema: nil, table: nil, column: nil, columns: nil)
			raise ArgumentError, "cannot specify both :column and :columns" if column && columns
			raise ArgumentError, "must specify :table if :schema specified" if schema && !table
			raise ArgumentError, "must specify either :table or :column(s)" if !table && !column && !columns

			@schema = schema
			@table = table
			@columns = Array(column) || columns
		end

		def to_s
			if		@schema && @table && @columns&.any?
				"#{@schema}.#{@table}(#{@columns.join(",")})"
			elsif @schema && @table && !@columns&.any?
				"#{@schema}.#{@table}"
			elsif	!@schema && @table && @columns&.any?
				"#{@table}(#{@columns.join(",")})"
			elsif	!@schema && !@table && @columns&.any?
				@columns.join(",")
			elsif	!@schema && @table && !@columns&.any?
				@table.to_s
			end
		end

		def inspect = "#{self.class.name.split("::").last}[#{self}]"

		def hash = @parts.hash

		def ==(other)
			other.is_a?(ColumnRef) && other.parts == @parts
		end
		alias_method :eql?, :==
	end

	class TableRef < ColumnRef
		def self.[](*args, **kwargs)
			raise ArgumentError, "cannot mix positional and keyword arguments" if args.any? && kwargs.any?

			if kwargs.any?
				new(**kwargs)
			elsif args.any?
				case args.size
				when 1
					new(table: args.first)
				when 2
					new(schema: args.first, table: args.last)
				else
					raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1..3)"
				end
			end
		end

		def initialize(schema: nil, table: nil)
			raise ArgumentError, "must specify :table" if !table

			@schema = schema
			@table = table
		end
	end

	def self.colref(*args, **kwargs)
		raise ArgumentError, "cannot mix positional and keyword arguments" if args.any? && kwargs.any?

		if kwargs.any?
			ColumnRef.new(**kwargs)
		elsif args.any?
			case args.size
			when 1
				ColumnRef.new(column: args.first)
			when 2
				ColumnRef.new(table: args.first, column: args.last)
			when 3
				ColumnRef.new(schema: args.first, table: args[1], column: args.last)
			else
				raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1..3)"
			end
		end
	end

	def self.tblref(*args, **kwargs)
		raise ArgumentError, "cannot mix positional and keyword arguments" if args.any? && kwargs.any?

		if kwargs.any?
			TableRef.new(**kwargs)
		elsif args.any?
			case args.size
			when 1
				TableRef.new(table: args.first)
			when 2
				TableRef.new(schema: args.first, table: args.last)
			else
				raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1..3)"
			end
		end
	end
end
