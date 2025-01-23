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

		def Keyword(tok, beg, fin)     = [tok, beg, fin, :keyword].freeze
		def Identifier(tok, beg, fin)  = [tok, beg, fin, :identifier].freeze
		def Punctuation(tok, beg, fin) = [tok, beg, fin, :punctuation].freeze
		def String(tok, beg, fin)      = [tok, beg, fin, :string].freeze
		def Numeric(tok, beg, fin)     = [tok, beg, fin, :numeric].freeze
		def Blob(tok, beg, fin)        = [tok, beg, fin, :blob].freeze
		def True(tok, beg, fin)        = [tok, beg, fin, :true].freeze
		def False(tok, beg, fin)       = [tok, beg, fin, :false].freeze
		def Null(tok, beg, fin)        = [tok, beg, fin, :null].freeze
		def Current(tok, beg, fin)     = [tok, beg, fin, :current].freeze

		def source(str, tup)
			_, beg, fin, _ = tup

			str.byteslice(beg, (fin - beg))
		end

		def value(str, tup)
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
			_, beg, fin, _ = tup

			[beg, fin].freeze
		end

		def ===(other)
			Tuple === other
		end

		private

		def numeric_literal(str, tup)
			tok, * = tup
			src = source(str, tup)

			case tok
			when :INTEGER
				src.to_i
			when :FLOAT
				src.to_f
			when :QNUMBER
				value = src.to_f
				value % 1 == 0 ? value.to_i : value
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
			when 96, 39, 34, 93 # "`", "'", '"', "]"
				bytesize = src.bytesize
				src.byteslice(1, bytesize - 2)
			else
				src
			end
		end
	end
end
