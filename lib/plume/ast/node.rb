# frozen_string_literal: true

module Plume
	class Node < Literal::Data
		prop :full_source, _Nilable(String) # , inspect: false
		# prop :loc, Location

		def self.inspect_props(*props)
			define_method :inspect do
				prop_values = props.map { |prop| "#{prop}=#{__send__(prop).inspect}" }
				"#<#{self.class.name}:#{object_id} #{prop_values.join(", ")}>"
			end
		end

		def self.token(name, required:)
			prop_type = required ? Token : _Nilable(Token)
			prop :"#{name}", prop_type, reader: false

			class_eval <<-RUBY, __FILE__, __LINE__ + 1
				# frozen_string_literal: true

				def #{name}_src
					Token.source(@full_source, @#{name})
				end

				def #{name}_val
					Token.value(@full_source, @#{name})
				end
				alias_method :#{name}, :#{name}_val

				def #{name}_loc
					Token.location(@#{name})
				end
			RUBY
		end

		def self.node(name, type, required:, collection: false)
			prop_type = collection ? _Array(type) : type
			prop_type = _Nilable(prop_type) unless required
			prop :"#{name}", prop_type
		end
	end
end
