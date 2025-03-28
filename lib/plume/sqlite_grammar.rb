# frozen_string_literal: true

require "net/http"
require "uri"

module Plume
	module SQLiteGrammar
		extend self

		PARSE_Y_URI = URI("https://raw.githubusercontent.com/sqlite/sqlite/refs/heads/master/src/parse.y").freeze
		RULE_PATTERN = /^(?:.+::=[^.]+\.)|(?:%token_class[^.]+\.)/.freeze
		IGNORED_SNIPPETS = [
			/^\/\//,
			/^scanpt.+::=/,
			/^scantok.+::=/,
		].freeze
		TOKEN_CLASS_SIGIL = '%token_class '.freeze

		def rules
			return @hash if defined? @hash

			# extract the SQL statements from the test files
			@hash = Hash.new { |h, k| h[k] = [] }
			matches = contents.scan(RULE_PATTERN)
			matches.each do |match|
				result = match.tap(&:strip!)
				next if IGNORED_SNIPPETS.any? { |it| result.match?(it) }

				if result.start_with?(TOKEN_CLASS_SIGIL)
					rule, definition = result.gsub(TOKEN_CLASS_SIGIL, '').split(/\s+/)
				else
					rule, definition = result.gsub(/\(.*?\)/, '').split(/\s+::=\s+/)
				end

				tokens = definition.chomp('.').tap(&:strip!).split(/\s+/)
				next (@hash[rule.strip] << tokens) if tokens.empty?

				sequences = tokens.map { |it| it.split('|') }.reduce(&:product).map{ |it| Array(it).flatten }
				sequences.each { |it| @hash[rule.strip] << it.reject { |it| ["scanpt", "scantok"].include?(it) } }
			end

			@hash
		end

		def token_names
			rules
				.values
				.flatten
				.uniq
				.select { |it| it.getbyte(0) <= 90 }
		end

		def rule_names
			rules.keys
		end

		def rules_with(token_or_rule)
			rules.select do |_, sequences|
				sequences.any? { |sequence| sequence.include? token_or_rule }
			end
		end

		def contents
			return @contents if defined? @contents

			# download the sqlite `parse.y` file for the master branch
			Net::HTTP.start(PARSE_Y_URI.host, PARSE_Y_URI.port, use_ssl: true) do |http|
				request = Net::HTTP::Get.new(PARSE_Y_URI)
				response = http.request(request)

				# Handle redirects
				if response.is_a?(Net::HTTPRedirection)
					uri = URI(response["location"])
					response = Net::HTTP.get_response(uri)
				end

				if response.is_a?(Net::HTTPSuccess)
					@contents = response.body
					return @contents
				else
					raise "Error: #{response.code} - #{response.message}"
				end
			end
		end
	end
end