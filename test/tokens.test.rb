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

test "tokenizes a space as SPACE" do
	assert_token " ", :SPACE
end

test "tokenizes a tab as SPACE" do
	assert_token "\t", :SPACE
end

test "tokenizes a newline as SPACE" do
	assert_token "\n", :SPACE
end

test "tokenizes a form feed as SPACE" do
	assert_token "\f", :SPACE
end

test "tokenizes a carriage return as SPACE" do
	assert_token "\r", :SPACE
end

test "tokenizes a continuous string of mixed whitespace stracters as SPACE" do
	assert_token " \t\n\f\r", :SPACE
end

test "tokenizes a minus sign as MINUS" do
	assert_token "-", :MINUS
end

test "tokenizes a double dash sign as a comment SPACE" do
	assert_token "--", :SPACE
end

test "tokenizes -> as PTR1 (pointer)" do
	assert_token "->", :PTR1
end

test "tokenizes ->> as PRT2 (pointer)" do
	assert_token "->>", :PTR2
end

test "tokenizes a full inline comment as SPACE" do
	assert_token "-- inline comment", :SPACE
end

test "tokenizes ( as LP" do
	assert_token "(", :LP
end

test "tokenizes ) as RP" do
	assert_token ")", :RP
end

test "tokenizes ; as SEMI" do
	assert_token ";", :SEMI
end

test "tokenizes + as PLUS" do
	assert_token "+", :PLUS
end

test "tokenizes * as STAR" do
	assert_token "*", :STAR
end

test "tokenizes % as REM" do
	assert_token "%", :REM
end

test "tokenizes , as COMMA" do
	assert_token ",", :COMMA
end

test "tokenizes & as BITAND" do
	assert_token "&", :BITAND
end

test "tokenizes ~ as BITNOT" do
	assert_token "~", :BITNOT
end

test "tokenizes = as EQ" do
	assert_token "=", :EQ
end

test "tokenizes == as EQ" do
	assert_token "==", :EQ
end

test "tokenizes . as DOT" do
	assert_token ".", :DOT
end

test "tokenizes / as SLASH" do
	assert_token "/", :SLASH
end

test "tokenizes a single line wrapped comment as SPACE" do
	assert_token "/* single line comment */", :SPACE
end

test "tokenizes a multi-line wrapped comment as SPACE" do
	assert_token "/* multi-line\ncomment */", :SPACE
end

test "tokenizes < as LT" do
	assert_token "<", :LT
end

test "tokenizes <= as LE" do
	assert_token "<=", :LE
end

test "tokenizes <> as NE" do
	assert_token "<>", :NE
end

test "tokenizes << as LSHIFT" do
	assert_token "<<", :LSHIFT
end

test "tokenizes > as GT" do
	assert_token ">", :GT
end

test "tokenizes >= as GE" do
	assert_token ">=", :GE
end

test "tokenizes >> as RSHIFT" do
	assert_token ">>", :RSHIFT
end

test "tokenizes != as NE" do
	assert_token "!=", :NE
end

test "tokenizes | as BITOR" do
	assert_token "|", :BITOR
end

test "tokenizes || as CONCAT" do
	assert_token "||", :CONCAT
end

test "tokenizes single quote wrapped strings as STRING" do
	assert_token "'abc'", :STRING
end

test "tokenizes single quote wrapped strings with escaped inner single quote as STRING" do
	assert_token "'abc''def'", :STRING
end

test "tokenizes a \xEF\xFE\xFF BOM as SPACE" do
	assert_token "\xEF\xFE\xFF", :SPACE
end

test "tokenizes a \\xEF\\x81 as ID" do
	assert_token "\xEF\x81", :ID
end

# ASCII control codes

test "tokenizes the ASCII Null (NUL) character as ILLEGAL" do
	assert_token "\x00", :ILLEGAL
end

test "tokenizes the ASCII Start of Heading (SOH) character as ILLEGAL" do
	assert_token "\x01", :ILLEGAL
end

test "tokenizes the ASCII Start of Text (STX) character as ILLEGAL" do
	assert_token "\x02", :ILLEGAL
end

test "tokenizes the ASCII End of Text (ETX) character as ILLEGAL" do
	assert_token "\x03", :ILLEGAL
end

test "tokenizes the ASCII End of Transmission (EOT) character as ILLEGAL" do
	assert_token "\x04", :ILLEGAL
end

test "tokenizes the ASCII Enquiry (ENQ) character as ILLEGAL" do
	assert_token "\x05", :ILLEGAL
end

test "tokenizes the ASCII Acknowledge (ACK) character as ILLEGAL" do
	assert_token "\x06", :ILLEGAL
end

test "tokenizes the ASCII Bell (BEL) character as ILLEGAL" do
	assert_token "\x07", :ILLEGAL
end

test "tokenizes the ASCII Backspace (BS) character as ILLEGAL" do
	assert_token "\x08", :ILLEGAL
end

test "tokenizes the ASCII Horizontal Tab (HT) character as SPACE" do
	assert_token "\x09", :SPACE
end

test "tokenizes the ASCII Line Feed (LF) character as SPACE" do
	assert_token "\x0A", :SPACE
end

test "tokenizes the ASCII Vertical Tab (VT) character as ILLEGAL" do
	assert_token "\x0B", :ILLEGAL
end

test "tokenizes the ASCII Form Feed (FF) character as SPACE" do
	assert_token "\x0C", :SPACE
end

test "tokenizes the ASCII Carriage Return (CR) character as SPACE" do
	assert_token "\x0D", :SPACE
end

test "tokenizes the ASCII Shift Out (SO) character as ILLEGAL" do
	assert_token "\x0E", :ILLEGAL
end

test "tokenizes the ASCII Shift In (SI) character as ILLEGAL" do
	assert_token "\x0F", :ILLEGAL
end

test "tokenizes the ASCII Data Link Escape (DLE) character as ILLEGAL" do
	assert_token "\x10", :ILLEGAL
end

test "tokenizes the ASCII Device Control 1 (DC1) character as ILLEGAL" do
	assert_token "\x11", :ILLEGAL
end

test "tokenizes the ASCII Device Control 2 (DC2) character as ILLEGAL" do
	assert_token "\x12", :ILLEGAL
end

test "tokenizes the ASCII Device Control 3 (DC3) character as ILLEGAL" do
	assert_token "\x13", :ILLEGAL
end

test "tokenizes the ASCII Device Control 4 (DC4) character as ILLEGAL" do
	assert_token "\x14", :ILLEGAL
end

test "tokenizes the ASCII Negative Acknowledge (NAK) character as ILLEGAL" do
	assert_token "\x15", :ILLEGAL
end

test "tokenizes the ASCII Synchronous Idle (SYN) character as ILLEGAL" do
	assert_token "\x16", :ILLEGAL
end

test "tokenizes the ASCII End of Transmission Block (ETB) character as ILLEGAL" do
	assert_token "\x17", :ILLEGAL
end

test "tokenizes the ASCII Cancel (CAN) character as ILLEGAL" do
	assert_token "\x18", :ILLEGAL
end

test "tokenizes the ASCII End of Medium (EM) character as ILLEGAL" do
	assert_token "\x19", :ILLEGAL
end

test "tokenizes the ASCII Substitute (SUB) character as ILLEGAL" do
	assert_token "\x1A", :ILLEGAL
end

test "tokenizes the ASCII Escape (ESC) character as ILLEGAL" do
	assert_token "\x1B", :ILLEGAL
end

test "tokenizes the ASCII File Separator (FS) character as ILLEGAL" do
	assert_token "\x1C", :ILLEGAL
end

test "tokenizes the ASCII Group Separator (GS) character as ILLEGAL" do
	assert_token "\x1D", :ILLEGAL
end

test "tokenizes the ASCII Record Separator (RS) character as ILLEGAL" do
	assert_token "\x1E", :ILLEGAL
end

test "tokenizes the ASCII Unit Separator (US) character as ILLEGAL" do
	assert_token "\x1F", :ILLEGAL
end

# identifiers

test "tokenizes a single letter as ID" do
	assert_token "a", :ID
end

test "tokenizes a single letter followed by a number as ID" do
	assert_token "a1", :ID
end

test "tokenizes double quote wrapped string as ID" do
	assert_token '"abc"', :ID
end

test "tokenizes double quote wrapped string with escaped inner double quote as ID" do
	assert_token '"abc""def"', :ID
end

test "tokenizes single double quote as ILLEGAL" do
	assert_token '"', :ILLEGAL
end

test "tokenizes tick wrapped string as ID" do
	assert_token "`abc`", :ID
end

test "tokenizes tick wrapped string with escaped inner tick as ID" do
	assert_token "`abc``def`", :ID
end

test "tokenizes single tick as ILLEGAL" do
	assert_token "`", :ILLEGAL
end

test "tokenizes square bracket wrapped string as ID" do
	assert_token "[abc]", :ID
end

test "tokenizes square bracket wrapped string with missing closing bracket as ILLEGAL" do
	assert_token "[abc", :ILLEGAL
end

test "tokenizes square bracket wrapped string with $ as ILLEGAL" do
	assert_token "[abc$", :ILLEGAL
end

test "tokenizes unassigned ASCII code points as ID" do
	assert_token "\x80", :ID
end

test "tokenizes string of unassigned code points as ID" do
	assert_token "\x80\x81\x82", :ID
end

test "tokenizes letter followed by $ as ID" do
	assert_token "a$", :ID
end

test "tokenizes letter followed by _ as ID" do
	assert_token "a_", :ID
end

test "tokenizes letters followed by $ as ID" do
	assert_token "abc$", :ID
end

test "tokenizes letters followed by _ as ID" do
	assert_token "abc_", :ID
end

# numerics

test "tokenizes a single 0 as INTEGER" do
	assert_token "0", :INTEGER
end

test "tokenizes a single 1 as INTEGER" do
	assert_token "1", :INTEGER
end

test "tokenizes a single 2 as INTEGER" do
	assert_token "2", :INTEGER
end

test "tokenizes a single 3 as INTEGER" do
	assert_token "3", :INTEGER
end

test "tokenizes a single 4 as INTEGER" do
	assert_token "4", :INTEGER
end

test "tokenizes a single 5 as INTEGER" do
	assert_token "5", :INTEGER
end

test "tokenizes a single 6 as INTEGER" do
	assert_token "6", :INTEGER
end

test "tokenizes a single 7 as INTEGER" do
	assert_token "7", :INTEGER
end

test "tokenizes a single 8 as INTEGER" do
	assert_token "8", :INTEGER
end

test "tokenizes a single 9 as INTEGER" do
	assert_token "9", :INTEGER
end

test "tokenizes multiple digits as INTEGER" do
	assert_token "123", :INTEGER
end

test "tokenizes 0x?? as INTEGER" do
	assert_token "0xFF", :INTEGER
end

test "tokenizes 0X?? as INTEGER" do
	assert_token "0XFF", :INTEGER
end

test "tokenizes 0x?????? as INTEGER" do
	assert_token "0x1234FF", :INTEGER
end

test "tokenizes 0X?????? as INTEGER" do
	assert_token "0X1234FF", :INTEGER
end

test "tokenizes digits separated by a dot as FLOAT" do
	assert_token "123.456", :FLOAT
end

test "tokenizes digits separated by a dot with no leading digit as FLOAT" do
	assert_token ".456", :FLOAT
end

test "tokenizes digits separated by a dot with no trailing digit as FLOAT" do
	assert_token "123.", :FLOAT
end

test "tokenizes digit followed by e and another digit as FLOAT" do
	assert_token "1e2", :FLOAT
end

test "tokenizes digits followed by e and more digits as FLOAT" do
	assert_token "123e456", :FLOAT
end

test "tokenizes digit followed by e+ and another digit as FLOAT" do
	assert_token "1e+2", :FLOAT
end

test "tokenizes digits followed by e+ and more digits as FLOAT" do
	assert_token "123e+456", :FLOAT
end

test "tokenizes digit followed by e- and another digit as FLOAT" do
	assert_token "1e-2", :FLOAT
end

test "tokenizes digits followed by e- and more digits as FLOAT" do
	assert_token "123e-456", :FLOAT
end

test "tokenizes digit followed by E and another digit as FLOAT" do
	assert_token "1E2", :FLOAT
end

test "tokenizes digits followed by E and more digits as FLOAT" do
	assert_token "123E456", :FLOAT
end

test "tokenizes digit followed by E+ and another digit as FLOAT" do
	assert_token "1E+2", :FLOAT
end

test "tokenizes digits followed by E+ and more digits as FLOAT" do
	assert_token "123E+456", :FLOAT
end

test "tokenizes digit followed by E- and another digit as FLOAT" do
	assert_token "1E-2", :FLOAT
end

test "tokenizes digits followed by E- and more digits as FLOAT" do
	assert_token "123E-456", :FLOAT
end

test "tokenizes digit followed by $ as ILLEGAL" do
	assert_token "1$", :ILLEGAL
end

test "tokenizes integers with underscores as QNUMBER" do
	assert_token "1_000", :QNUMBER
end

test "tokenizes floats with underscores in whole number as QNUMBER" do
	assert_token "1_000.123", :QNUMBER
end

test "tokenizes floats with underscores in decimal number as QNUMBER" do
	assert_token "123.1_000", :QNUMBER
end

test "tokenizes exponentials with underscores in base as QNUMBER" do
	assert_token "1_000E+2", :QNUMBER
end

test "tokenizes exponentials with underscores in exponent as QNUMBER" do
	assert_token "1E+2_000", :QNUMBER
end

test "tokenizes hex integer as QNUMBER" do
	assert_token "0X123_456", :QNUMBER
end

# variables

test "tokenizes ? as VARIABLE" do
	assert_token "?", :VARIABLE
end

test "tokenizes ? followed by digit as VARIABLE" do
	assert_token "?1", :VARIABLE
end

test "tokenizes ? followed by digits as VARIABLE" do
	assert_token "?123", :VARIABLE
end

test "tokenizes bare $ as ILLEGAL" do
	assert_token "$", :ILLEGAL
end

test "tokenizes $ followed by digit as VARIABLE" do
	assert_token "$1", :VARIABLE
end

test "tokenizes $ followed by digits as VARIABLE" do
	assert_token "$123", :VARIABLE
end

test "tokenizes $ followed by letter as VARIABLE" do
	assert_token "$a", :VARIABLE
end

test "tokenizes $ followed by letters as VARIABLE" do
	assert_token "$abc", :VARIABLE
end

test "tokenizes $ followed by letters and :: as VARIABLE" do
	assert_token "$foo::bar", :VARIABLE
end

test "tokenizes $ followed by letters and :: and (...) as VARIABLE" do
	assert_token "$foo::bar(baz)", :VARIABLE
end

test "tokenizes $ followed by letters and :: and (... as ILLEGAL" do
	assert_token "$foo::bar(baz", :ILLEGAL
end

test "tokenizes bare @ as ILLEGAL" do
	assert_token "@", :ILLEGAL
end

test "tokenizes @ followed by digit as VARIABLE" do
	assert_token "@1", :VARIABLE
end

test "tokenizes @ followed by digits as VARIABLE" do
	assert_token "@123", :VARIABLE
end

test "tokenizes @ followed by letter as VARIABLE" do
	assert_token "@a", :VARIABLE
end

test "tokenizes @ followed by letters as VARIABLE" do
	assert_token "@abc", :VARIABLE
end

test "tokenizes bare : as ILLEGAL" do
	assert_token ":", :ILLEGAL
end

test "tokenizes : followed by digit as VARIABLE" do
	assert_token ":1", :VARIABLE
end

test "tokenizes : followed by digits as VARIABLE" do
	assert_token ":123", :VARIABLE
end

test "tokenizes : followed by letter as VARIABLE" do
	assert_token ":a", :VARIABLE
end

test "tokenizes : followed by letters as VARIABLE" do
	assert_token ":abc", :VARIABLE
end

test "tokenizes bare # as ILLEGAL" do
	assert_token "#", :ILLEGAL
end

test "tokenizes # followed by digit as VARIABLE" do
	assert_token "#1", :VARIABLE
end

test "tokenizes # followed by digits as VARIABLE" do
	assert_token "#123", :VARIABLE
end

test "tokenizes # followed by letter as VARIABLE" do
	assert_token "#a", :VARIABLE
end

test "tokenizes # followed by letters as VARIABLE" do
	assert_token "#abc", :VARIABLE
end

test "tokenizes x as ID" do
	assert_token "x", :ID
end

test "tokenizes xyz as ID" do
	assert_token "xyz", :ID
end

# blobs

test "tokenizes x'' as BLOB" do
	assert_token "x''", :BLOB
end

test "tokenizes x'' with even number of alphanumeric characters as BLOB" do
	assert_token "x'abcdEF12'", :BLOB
end

test "tokenizes x'' with even number of symbols as ILLEGAL" do
	assert_token "x'abcdEF12$#'", :ILLEGAL
end

test "tokenizes x'' with odd number of alphanumeric characters as ILLEGAL" do
	assert_token "x'abcdEF123'", :ILLEGAL
end

test "tokenizes x' with missing closing single quote as ILLEGAL" do
	assert_token "x'", :ILLEGAL
end

test "tokenizes x' with even number of alphanumeric characters but missing closing single quote as ILLEGAL" do
	assert_token "x'abcdEF12", :ILLEGAL
end

test "tokenizes X'' as BLOB" do
	assert_token "X''", :BLOB
end

test "tokenizes X'' with even number of alphanumeric characters as BLOB" do
	assert_token "X'abcdEF12'", :BLOB
end

test "tokenizes X'' with even number of symbols as ILLEGAL" do
	assert_token "X'abcdEF12$#'", :ILLEGAL
end

test "tokenizes X'' with odd number of alphanumeric characters as ILLEGAL" do
	assert_token "X'abcdEF123'", :ILLEGAL
end

test "tokenizes X' with missing closing single quote as ILLEGAL" do
	assert_token "X'", :ILLEGAL
end

test "tokenizes X' with even number of alphanumeric characters but missing closing single quote as ILLEGAL" do
	assert_token "X'abcdEF12", :ILLEGAL
end

# keywords

test "tokenizes ABORT as ABORT" do
	assert_token "ABORT", :ABORT
end

test "tokenizes ACTION as ACTION" do
	assert_token "ACTION", :ACTION
end

test "tokenizes ADD as ADD" do
	assert_token "ADD", :ADD
end

test "tokenizes AFTER as AFTER" do
	assert_token "AFTER", :AFTER
end

test "tokenizes ALL as ALL" do
	assert_token "ALL", :ALL
end

test "tokenizes ALTER as ALTER" do
	assert_token "ALTER", :ALTER
end

test "tokenizes ALWAYS as ALWAYS" do
	assert_token "ALWAYS", :ALWAYS
end

test "tokenizes ANALYZE as ANALYZE" do
	assert_token "ANALYZE", :ANALYZE
end

test "tokenizes AND as AND" do
	assert_token "AND", :AND
end

test "tokenizes AS as AS" do
	assert_token "AS", :AS
end

test "tokenizes ASC as ASC" do
	assert_token "ASC", :ASC
end

test "tokenizes ATTACH as ATTACH" do
	assert_token "ATTACH", :ATTACH
end

test "tokenizes AUTOINCREMENT as AUTOINCREMENT" do
	assert_token "AUTOINCREMENT", :AUTOINCREMENT
end

test "tokenizes BEFORE as BEFORE" do
	assert_token "BEFORE", :BEFORE
end

test "tokenizes BEGIN as BEGIN" do
	assert_token "BEGIN", :BEGIN
end

test "tokenizes BETWEEN as BETWEEN" do
	assert_token "BETWEEN", :BETWEEN
end

test "tokenizes BY as BY" do
	assert_token "BY", :BY
end

test "tokenizes CASCADE as CASCADE" do
	assert_token "CASCADE", :CASCADE
end

test "tokenizes CASE as CASE" do
	assert_token "CASE", :CASE
end

test "tokenizes CAST as CAST" do
	assert_token "CAST", :CAST
end

test "tokenizes CHECK as CHECK" do
	assert_token "CHECK", :CHECK
end

test "tokenizes COLLATE as COLLATE" do
	assert_token "COLLATE", :COLLATE
end

test "tokenizes COLUMN as COLUMN" do
	assert_token "COLUMN", :COLUMN
end

test "tokenizes COMMIT as COMMIT" do
	assert_token "COMMIT", :COMMIT
end

test "tokenizes CONFLICT as CONFLICT" do
	assert_token "CONFLICT", :CONFLICT
end

test "tokenizes CONSTRAINT as CONSTRAINT" do
	assert_token "CONSTRAINT", :CONSTRAINT
end

test "tokenizes CREATE as CREATE" do
	assert_token "CREATE", :CREATE
end

test "tokenizes CROSS as CROSS" do
	assert_token "CROSS", :CROSS
end

test "tokenizes CURRENT as CURRENT" do
	assert_token "CURRENT", :CURRENT
end

test "tokenizes CURRENT_DATE as CURRENT_DATE" do
	assert_token "CURRENT_DATE", :CURRENT_DATE
end

test "tokenizes CURRENT_TIME as CURRENT_TIME" do
	assert_token "CURRENT_TIME", :CURRENT_TIME
end

test "tokenizes CURRENT_TIMESTAMP as CURRENT_TIMESTAMP" do
	assert_token "CURRENT_TIMESTAMP", :CURRENT_TIMESTAMP
end

test "tokenizes DATABASE as DATABASE" do
	assert_token "DATABASE", :DATABASE
end

test "tokenizes DEFAULT as DEFAULT" do
	assert_token "DEFAULT", :DEFAULT
end

test "tokenizes DEFERRED as DEFERRED" do
	assert_token "DEFERRED", :DEFERRED
end

test "tokenizes DEFERRABLE as DEFERRABLE" do
	assert_token "DEFERRABLE", :DEFERRABLE
end

test "tokenizes DELETE as DELETE" do
	assert_token "DELETE", :DELETE
end

test "tokenizes DESC as DESC" do
	assert_token "DESC", :DESC
end

test "tokenizes DETACH as DETACH" do
	assert_token "DETACH", :DETACH
end

test "tokenizes DISTINCT as DISTINCT" do
	assert_token "DISTINCT", :DISTINCT
end

test "tokenizes DO as DO" do
	assert_token "DO", :DO
end

test "tokenizes DROP as DROP" do
	assert_token "DROP", :DROP
end

test "tokenizes END as END" do
	assert_token "END", :END
end

test "tokenizes EACH as EACH" do
	assert_token "EACH", :EACH
end

test "tokenizes ELSE as ELSE" do
	assert_token "ELSE", :ELSE
end

test "tokenizes ESCAPE as ESCAPE" do
	assert_token "ESCAPE", :ESCAPE
end

test "tokenizes EXCEPT as EXCEPT" do
	assert_token "EXCEPT", :EXCEPT
end

test "tokenizes EXCLUSIVE as EXCLUSIVE" do
	assert_token "EXCLUSIVE", :EXCLUSIVE
end

test "tokenizes EXCLUDE as EXCLUDE" do
	assert_token "EXCLUDE", :EXCLUDE
end

test "tokenizes EXISTS as EXISTS" do
	assert_token "EXISTS", :EXISTS
end

test "tokenizes EXPLAIN as EXPLAIN" do
	assert_token "EXPLAIN", :EXPLAIN
end

test "tokenizes FAIL as FAIL" do
	assert_token "FAIL", :FAIL
end

test "tokenizes FILTER as FILTER" do
	assert_token "FILTER", :FILTER
end

test "tokenizes FIRST as FIRST" do
	assert_token "FIRST", :FIRST
end

test "tokenizes FOLLOWING as FOLLOWING" do
	assert_token "FOLLOWING", :FOLLOWING
end

test "tokenizes FOR as FOR" do
	assert_token "FOR", :FOR
end

test "tokenizes FOREIGN as FOREIGN" do
	assert_token "FOREIGN", :FOREIGN
end

test "tokenizes FROM as FROM" do
	assert_token "FROM", :FROM
end

test "tokenizes FULL as FULL" do
	assert_token "FULL", :FULL
end

test "tokenizes GENERATED as GENERATED" do
	assert_token "GENERATED", :GENERATED
end

test "tokenizes GLOB as GLOB" do
	assert_token "GLOB", :GLOB
end

test "tokenizes GROUP as GROUP" do
	assert_token "GROUP", :GROUP
end

test "tokenizes GROUPS as GROUPS" do
	assert_token "GROUPS", :GROUPS
end

test "tokenizes HAVING as HAVING" do
	assert_token "HAVING", :HAVING
end

test "tokenizes IF as IF" do
	assert_token "IF", :IF
end

test "tokenizes IGNORE as IGNORE" do
	assert_token "IGNORE", :IGNORE
end

test "tokenizes IMMEDIATE as IMMEDIATE" do
	assert_token "IMMEDIATE", :IMMEDIATE
end

test "tokenizes IN as IN" do
	assert_token "IN", :IN
end

test "tokenizes INDEX as INDEX" do
	assert_token "INDEX", :INDEX
end

test "tokenizes INDEXED as INDEXED" do
	assert_token "INDEXED", :INDEXED
end

test "tokenizes INITIALLY as INITIALLY" do
	assert_token "INITIALLY", :INITIALLY
end

test "tokenizes INNER as INNER" do
	assert_token "INNER", :INNER
end

test "tokenizes INSERT as INSERT" do
	assert_token "INSERT", :INSERT
end

test "tokenizes INSTEAD as INSTEAD" do
	assert_token "INSTEAD", :INSTEAD
end

test "tokenizes INTERSECT as INTERSECT" do
	assert_token "INTERSECT", :INTERSECT
end

test "tokenizes INTO as INTO" do
	assert_token "INTO", :INTO
end

test "tokenizes IS as IS" do
	assert_token "IS", :IS
end

test "tokenizes ISNULL as ISNULL" do
	assert_token "ISNULL", :ISNULL
end

test "tokenizes JOIN as JOIN" do
	assert_token "JOIN", :JOIN
end

test "tokenizes KEY as KEY" do
	assert_token "KEY", :KEY
end

test "tokenizes LAST as LAST" do
	assert_token "LAST", :LAST
end

test "tokenizes LEFT as LEFT" do
	assert_token "LEFT", :LEFT
end

test "tokenizes LIKE as LIKE" do
	assert_token "LIKE", :LIKE
end

test "tokenizes LIMIT as LIMIT" do
	assert_token "LIMIT", :LIMIT
end

test "tokenizes MATCH as MATCH" do
	assert_token "MATCH", :MATCH
end

test "tokenizes MATERIALIZED as MATERIALIZED" do
	assert_token "MATERIALIZED", :MATERIALIZED
end

test "tokenizes NATURAL as NATURAL" do
	assert_token "NATURAL", :NATURAL
end

test "tokenizes NO as NO" do
	assert_token "NO", :NO
end

test "tokenizes NOT as NOT" do
	assert_token "NOT", :NOT
end

test "tokenizes NOTHING as NOTHING" do
	assert_token "NOTHING", :NOTHING
end

test "tokenizes NOTNULL as NOTNULL" do
	assert_token "NOTNULL", :NOTNULL
end

test "tokenizes NULL as NULL" do
	assert_token "NULL", :NULL
end

test "tokenizes NULLS as NULLS" do
	assert_token "NULLS", :NULLS
end

test "tokenizes OF as OF" do
	assert_token "OF", :OF
end

test "tokenizes OFFSET as OFFSET" do
	assert_token "OFFSET", :OFFSET
end

test "tokenizes ON as ON" do
	assert_token "ON", :ON
end

test "tokenizes OR as OR" do
	assert_token "OR", :OR
end

test "tokenizes ORDER as ORDER" do
	assert_token "ORDER", :ORDER
end

test "tokenizes OTHERS as OTHERS" do
	assert_token "OTHERS", :OTHERS
end

test "tokenizes OUTER as OUTER" do
	assert_token "OUTER", :OUTER
end

test "tokenizes OVER as OVER" do
	assert_token "OVER", :OVER
end

test "tokenizes PARTITION as PARTITION" do
	assert_token "PARTITION", :PARTITION
end

test "tokenizes PLAN as PLAN" do
	assert_token "PLAN", :PLAN
end

test "tokenizes PRAGMA as PRAGMA" do
	assert_token "PRAGMA", :PRAGMA
end

test "tokenizes PRECEDING as PRECEDING" do
	assert_token "PRECEDING", :PRECEDING
end

test "tokenizes PRIMARY as PRIMARY" do
	assert_token "PRIMARY", :PRIMARY
end

test "tokenizes QUERY as QUERY" do
	assert_token "QUERY", :QUERY
end

test "tokenizes RAISE as RAISE" do
	assert_token "RAISE", :RAISE
end

test "tokenizes RANGE as RANGE" do
	assert_token "RANGE", :RANGE
end

test "tokenizes RECURSIVE as RECURSIVE" do
	assert_token "RECURSIVE", :RECURSIVE
end

test "tokenizes REFERENCES as REFERENCES" do
	assert_token "REFERENCES", :REFERENCES
end

test "tokenizes REGEXP as REGEXP" do
	assert_token "REGEXP", :REGEXP
end

test "tokenizes REINDEX as REINDEX" do
	assert_token "REINDEX", :REINDEX
end

test "tokenizes RELEASE as RELEASE" do
	assert_token "RELEASE", :RELEASE
end

test "tokenizes RENAME as RENAME" do
	assert_token "RENAME", :RENAME
end

test "tokenizes REPLACE as REPLACE" do
	assert_token "REPLACE", :REPLACE
end

test "tokenizes RESTRICT as RESTRICT" do
	assert_token "RESTRICT", :RESTRICT
end

test "tokenizes RETURNING as RETURNING" do
	assert_token "RETURNING", :RETURNING
end

test "tokenizes RIGHT as RIGHT" do
	assert_token "RIGHT", :RIGHT
end

test "tokenizes ROLLBACK as ROLLBACK" do
	assert_token "ROLLBACK", :ROLLBACK
end

test "tokenizes ROW as ROW" do
	assert_token "ROW", :ROW
end

test "tokenizes ROWS as ROWS" do
	assert_token "ROWS", :ROWS
end

test "tokenizes SAVEPOINT as SAVEPOINT" do
	assert_token "SAVEPOINT", :SAVEPOINT
end

test "tokenizes SELECT as SELECT" do
	assert_token "SELECT", :SELECT
end

test "tokenizes SET as SET" do
	assert_token "SET", :SET
end

test "tokenizes TABLE as TABLE" do
	assert_token "TABLE", :TABLE
end

test "tokenizes TEMP as TEMP" do
	assert_token "TEMP", :TEMP
end

test "tokenizes TEMPORARY as TEMPORARY" do
	assert_token "TEMPORARY", :TEMPORARY
end

test "tokenizes THEN as THEN" do
	assert_token "THEN", :THEN
end

test "tokenizes TIES as TIES" do
	assert_token "TIES", :TIES
end

test "tokenizes TO as TO" do
	assert_token "TO", :TO
end

test "tokenizes TRANSACTION as TRANSACTION" do
	assert_token "TRANSACTION", :TRANSACTION
end

test "tokenizes TRIGGER as TRIGGER" do
	assert_token "TRIGGER", :TRIGGER
end

test "tokenizes UNBOUNDED as UNBOUNDED" do
	assert_token "UNBOUNDED", :UNBOUNDED
end

test "tokenizes UNION as UNION" do
	assert_token "UNION", :UNION
end

test "tokenizes UNIQUE as UNIQUE" do
	assert_token "UNIQUE", :UNIQUE
end

test "tokenizes UPDATE as UPDATE" do
	assert_token "UPDATE", :UPDATE
end

test "tokenizes USING as USING" do
	assert_token "USING", :USING
end

test "tokenizes VACUUM as VACUUM" do
	assert_token "VACUUM", :VACUUM
end

test "tokenizes VALUES as VALUES" do
	assert_token "VALUES", :VALUES
end

test "tokenizes VIEW as VIEW" do
	assert_token "VIEW", :VIEW
end

test "tokenizes VIRTUAL as VIRTUAL" do
	assert_token "VIRTUAL", :VIRTUAL
end

test "tokenizes WHEN as WHEN" do
	assert_token "WHEN", :WHEN
end

test "tokenizes WHERE as WHERE" do
	assert_token "WHERE", :WHERE
end

test "tokenizes WINDOW as WINDOW" do
	assert_token "WINDOW", :WINDOW
end

test "tokenizes WITH as WITH" do
	assert_token "WITH", :WITH
end

test "tokenizes WITHOUT as WITHOUT" do
	assert_token "WITHOUT", :WITHOUT
end

# token pairs

test "tokenizes /1 as SLASH, INTEGER" do
	tokens = lex "/1"
	assert_equal [:SLASH, :INTEGER], tokens
end

test "tokenizes !- as ILLEGAL, MINUS" do
	tokens = lex "!-"
	assert_equal [:ILLEGAL, :MINUS], tokens
end

test "tokenizes .a as DOT, ID" do
	tokens = lex ".a"
	assert_equal [:DOT, :ID], tokens
end

test "tokenizes integers with underscores followed by / as QNUMBER, SLASH" do
	tokens = lex "1_000/"
	assert_equal [:QNUMBER, :SLASH], tokens
end

test "tokenizes floats with underscores followed by / as QNUMBER, SLASH" do
	tokens = lex "1_000.123/"
	assert_equal [:QNUMBER, :SLASH], tokens
end

test "tokenizes exponentials with underscores followed by / as QNUMBER, SLASH" do
	tokens = lex "1_000E+2/"
	assert_equal [:QNUMBER, :SLASH], tokens
end

test "tokenizes hex integer followed by / as QNUMBER, SLASH" do
	tokens = lex "0X123_456/"
	assert_equal [:QNUMBER, :SLASH], tokens
end

test "tokenizes VARIABLE, SLASH" do
	tokens = lex "$abc/"
	assert_equal [:VARIABLE, :SLASH], tokens
end

# illegal strings

test "tokenizes 1.0e+ as ILLEGAL, PLUS" do
	tokens = lex "1.0e+"
	assert_equal [:ILLEGAL, :PLUS], tokens
end

test "tokenizes 1.0E+ as ILLEGAL, PLUS" do
	tokens = lex "1.0E+"
	assert_equal [:ILLEGAL, :PLUS], tokens
end

test "tokenizes 1.0e- as ILLEGAL, MINUS" do
	tokens = lex "1.0e-"
	assert_equal [:ILLEGAL, :MINUS], tokens
end

test "tokenizes 1.0E- as ILLEGAL, MINUS" do
	tokens = lex "1.0E-"
	assert_equal [:ILLEGAL, :MINUS], tokens
end

test "tokenizes 1.0e+/ as ILLEGAL, PLUS, SLASH" do
	tokens = lex "1.0e+/"
	assert_equal [:ILLEGAL, :PLUS, :SLASH], tokens
end

test "tokenizes 1.0E+: as ILLEGAL, PLUS, ILLEGAL" do
	tokens = lex "1.0E+:"
	assert_equal [:ILLEGAL, :PLUS, :ILLEGAL], tokens
end

test "tokenizes 1.0e-: as ILLEGAL, MINUS, ILLEGAL" do
	tokens = lex "1.0e-:"
	assert_equal [:ILLEGAL, :MINUS, :ILLEGAL], tokens
end

test "tokenizes 1.0E-/ as ILLEGAL, MINUS, SLASH" do
	tokens = lex "1.0E-/"
	assert_equal [:ILLEGAL, :MINUS, :SLASH], tokens
end

test "tokenizes 1.0F+5 as ILLEGAL, PLUS, INTEGER" do
	tokens = lex "1.0F+5"
	assert_equal [:ILLEGAL, :PLUS, :INTEGER], tokens
end

test "tokenizes 1.0d-10 as ILLEGAL, MINUS, INTEGER" do
	tokens = lex "1.0d-10"
	assert_equal [:ILLEGAL, :MINUS, :INTEGER], tokens
end

test "tokenizes 1.0e,5 as ILLEGAL, COMMA, INTEGER" do
	tokens = lex "1.0e,5"
	assert_equal [:ILLEGAL, :COMMA, :INTEGER], tokens
end

test "tokenizes 1.0E.10 as ILLEGAL, FLOAT" do
	tokens = lex "1.0E.10"
	assert_equal [:ILLEGAL, :FLOAT], tokens
end

test "tokenizes 2 /* as INTEGER, SPACE, SPACE" do
	tokens = lex "2 /*"
	assert_equal [:INTEGER, :SPACE, :SPACE], tokens
end

test "tokenizes 2 /*  as INTEGER, SPACE, SPACE" do
	tokens = lex "2 /* "
	assert_equal [:INTEGER, :SPACE, :SPACE], tokens
end

# tokens with values

test "tokenizes 2 /*  as INTEGER, SPACE, SPACE" do
	tokens = lex "2 /* ", with_values: true
	assert_equal [[:INTEGER, "2"], [:SPACE, " "], [:SPACE, "/* "]], tokens
end

# UTF16 strings

test "tokenizes UTF16 string as ID" do
	assert_token "\u{3042}".encode(Encoding::UTF_16), :ID
end