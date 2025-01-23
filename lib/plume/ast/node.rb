# frozen_string_literal: true

module Plume
	class Node < Literal::Data
		prop :full_source, _Nilable(String) # , inspect: false
		# prop :loc, Location

		def self.inspect_props(*props)
			@inspectable_props ||= Set.new
			@inspectable_props.merge(props)
		end

		def inspect
			return super unless self.class.instance_variable_defined?(:@inspectable_props)

			inspectable_props = self.class.instance_variable_get(:@inspectable_props)
			prop_values = inspectable_props.map do |prop|
				val = __send__(prop)
				next if val.nil?

				"#{prop}=#{val.inspect}"
			end.compact!

			"#<#{self.class.name}:#{object_id} #{prop_values.join(", ")}>"
		end

		def self.token(name, required:, inspect: false)
			prop_type = required ? Token : _Nilable(Token)
			prop :"#{name}", prop_type, reader: false
			inspect_props(name) if inspect

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

		def self.node(name, type, required:, collection: false, inspect: true)
			prop_type = collection ? _Array(type) : type
			prop_type = _Nilable(prop_type) unless required
			prop :"#{name}", prop_type
			inspect_props(name) if inspect
		end
	end
end
