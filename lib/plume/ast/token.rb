# frozen_string_literal: true

module Plume
	module Token
		extend Literal::Types
		extend self

		Type = _Union(
			:keyword,
			:identifier,
			:punctuation,
			:string,
			:numeric,
			:blob,
			:true,
			:false,
			:null,
			:current,
		)

		Tuple = _Tuple(_Union(Symbol, _Array(Symbol)), Integer, Integer, Type)

		def Keyword(arg)
			[*arg, :keyword] if arg
		end

		def Identifier(arg)
			[*arg, :identifier] if arg
		end

		def Punctuation(arg)
			[*arg, :punctuation] if arg
		end

		def String(arg)
			[*arg, :string] if arg
		end

		def Numeric(arg)
			[*arg, :numeric] if arg
		end

		def Blob(arg)
			[*arg, :blob] if arg
		end

		def True(arg)
			[*arg, :true] if arg
		end

		def False(arg)
			[*arg, :false] if arg
		end

		def Null(arg)
			[*arg, :null] if arg
		end

		def Current(arg)
			[*arg, :current] if arg
		end

		def source(str, tup)
			return unless str && tup

			_, beg, fin, = tup

			str.byteslice(beg, (fin - beg))
		end

		def value(str, tup)
			return unless str && tup

			*, type = tup

			case type
			when :null        then LiteralNil
			when :true        then true
			when :false       then LiteralFalse
			when :current     then source(str, tup).to_sym.upcase
			when :numeric     then numeric_literal(str, tup)
			when :string      then string_literal(str, tup)
			when :blob        then blob_literal(str, tup)
			when :keyword     then source(str, tup)
			when :identifier  then identifier(str, tup)
			when :punctuation then source(str, tup)
			end
		end

		def location(tup)
			return unless tup

			_, beg, fin, = tup

			[beg, fin].freeze
		end

		def token(tup)
			return unless tup

			tok, * = tup

			tok
		end

		def ===(other)
			Tuple === other
		end

		private

		def numeric_literal(str, tup)
			tok, * = tup
			src = source(str, tup)

			case tok
			when :INTEGER, [:PLUS, :INTEGER], [:MINUS, :INTEGER]
				src.to_i
			when :FLOAT, [:PLUS, :FLOAT], [:MINUS, :FLOAT]
				src.to_f
			when :QNUMBER, [:PLUS, :QNUMBER], [:MINUS, :QNUMBER]
				value = src.to_f
				(value % 1 == 0) ? value.to_i : value
			end
		end

		def string_literal(str, tup)
			src = source(str, tup)
			bytesize = src.bytesize
			# strip the leading and trailing quotes
			src.byteslice(1, bytesize - 2)
		end

		def blob_literal(str, tup)
			src = source(str, tup)
			bytesize = value.bytesize
			# trim the leading /x'/i and trailing /'/ then decode the hexadecimal string
			[value.byteslice(2, bytesize - 3)].pack("H*")
		end

		def identifier(str, tup)
			tok, * = tup

			return string_literal(str, tup) if tok == :STRING

			src = source(str, tup)

			return src if tok != :ID

			case src.getbyte(0)
			when 96, 39, 34, 91 # "`", "'", '"', "["
				bytesize = src.bytesize
				src.byteslice(1, bytesize - 2)
			else
				src
			end
		end
	end
end