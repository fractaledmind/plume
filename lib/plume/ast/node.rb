# frozen_string_literal: true

module Plume
	class Node < Literal::Data
		prop :full_source, _Nilable(String) # , inspect: false
		# prop :loc, Location

		def self.inspectable(*props)
			@inspectable_props ||= Set.new
			@inspectable_props.merge(props)
		end

		def self.all_inspectable_props
			ancestors.reduce(Set.new) do |all_props, ancestor|
				if (props = ancestor.instance_variable_get(:@inspectable_props))
					all_props.merge(props)
				else
					all_props
				end
			end
		end

		alias_method :full_inspect, :inspect
		def inspect
			inspectable_props = self.class.all_inspectable_props
			return super if inspectable_props.nil? || inspectable_props.empty?

			prop_values = inspectable_props.map do |prop|
				val = __send__(prop)
				next if val.nil? || (val.respond_to?(:empty?) && val.empty?)

				"#{prop}=#{val.inspect}"
			end.tap(&:compact!)

			"#<#{self.class.name}:#{object_id} #{prop_values&.join(", ")}>"
		end

		def self.required_token(name, **)
			token(name, required: true, **)
		end

		def self.optional_token(name, **)
			token(name, required: false, **)
		end

		def self.required_node(name, type, **)
			node(name, type, required: true, **)
		end

		def self.optional_node(name, type, **)
			node(name, type, required: false, **)
		end

		def self.required_nodes(name, type, **)
			node(name, type, required: true, collection: true, **)
		end

		def self.optional_nodes(name, type, **)
			node(name, type, required: false, collection: true, **)
		end

		def self.token(name, required:, reader: nil, default: nil, type: nil, inspect: false)
			# If a `reader` is provided, the class must be able to be initialized directly with a `reader` value.
			# Thus, the token property must be nilable.
			prop_type = (reader || !required) ? _Nilable(Token) : Token
			# Regardless of whether a `reader` is provided, a custom reader method will be defined.
			prop :"#{name}", prop_type, reader: false

			if reader
				# A token's `reader` value is expected to be the provided `type`, or a String, Symbol, or Node
				prop_type = type ? type : _Union(String, Symbol, Node)
				# The property is nilable so that the class can be initialized only with the token value,
				# as will be the case from the Parser.
				prop :"#{reader}", _Nilable(prop_type), reader: false
				# When a `reader` is provided, it should always be inspectable.
				inspectable(reader)
				# The custom reader method returns either the initialized `reader` value or
				# the value returned by the `default` block, executed in the context of the instance.
				define_method(reader) do
					instance_variable_get("@#{reader}") || instance_exec(&default)
				end

				# When a token is marked as required, we require that either the token or the reader value
				# is present when the class is initialized.
				if required
					class_eval <<-RUBY, __FILE__, __LINE__ + 1
						# frozen_string_literal: true
						def after_initialize
							raise ArgumentError.new("#{name} and #{reader} cannot both be nil") if @#{name}.nil? && @#{reader}.nil?
						end
					RUBY
				end
			end

			# Define methods for accessing token properties, like the original source text, parsed value, and location.
			# The token reader method is simply the parsed value of the token.
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

				def #{name}_tok
					Token.token(@#{name})
				end
			RUBY
		end

		def self.node(name, type, required: true, collection: false, inspect: true)
			prop_type = collection ? _Array(type) : type
			prop_type = _Nilable(prop_type) unless required
			prop :"#{name}", prop_type
			inspectable(name) if inspect
		end
	end
end