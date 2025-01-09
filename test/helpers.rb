# frozen_string_literal: true

def lex(str, with_values: false)
	lex = Plume::Lexer.new(str)
	lex.tokens(with_values).to_a
end

def assert_token(str, tk)
	lex = Plume::Lexer.new(str)

	token = lex.next_token
	assert(tk == token) do
		"expected #{tk.inspect} to == #{token.inspect}"
	end

	final = lex.next_token
	assert(final == nil) do
		"expected #{final.inspect} to be nil"
	end
end
