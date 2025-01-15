# frozen_string_literal: true

snippets = Set[]

paths = Dir.glob("./fixtures/sqlite/test/**/*")

pattern = /\s(?:execsql|db\s+eval)[^}]*\{([^}]+)\}/m

paths.each do |path|
	next if File.directory?(path)
	next if path.end_with?(".db")
	contents = File.read(path)

	pattern.match(contents) do |match|
		result =  match[1].lines.map(&:strip).join("\n").strip
		snippets << result unless result.start_with?("$")
	end
end

snippets.each do |snippet|
	test do
		Plume::Parser.new(snippet).parse
	rescue Plume::Parser::SyntaxError => e
		failure! { snippet }
	end
end
