# frozen_string_literal: true

snippets = Set[]

paths = Dir.glob("./fixtures/sqlite/test/**/*.{test,tcl}")

pattern = /\s(?:execsql|db\s+eval)[^{\n]*\{([^}]+)\}/mi
stmt_re = /\A(?:ALTER|ANALYZE|ATTACH|BEGIN|COMMIT|END|EXPLAIN|CREATE|DELETE|DETACH|DROP|INSERT|REPLACE|PRAGMA|REINDEX|RELEASE|ROLLBACK|SAVEPOINT|SELECT|UPDATE|VACU
UM|WITH|--\s)\b/i
ignored_snippets = Set[
	"CREATE TABLE $tbl AS $select",
	"CREATE TABLE %T%(x, y);",
	"$::temp",
]

paths.each do |path|
	contents = File.read(path)
	matches = contents.scan(pattern)
	matches.each do |match|
		result = match[0].lines.map(&:strip).join("\n").strip
		next unless result.match?(stmt_re)
		next if ignored_snippets.any? { |it| result.include?(it) }

		snippets << result
	end
end

snippets.each do |snippet|
	test do
		Plume::Parser.new(snippet).parse
		success!
	rescue => e
		failure! { snippet }
	end
end
