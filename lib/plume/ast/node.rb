# frozen_string_literal: true

module Plume
	class Node < Literal::Struct
		Stringy = _Union(String, Symbol)

		prop :full_source, _Nilable(String)
		prop :leading, _Nilable(Token)
		prop :trailing, _Nilable(Token)

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

		def self.concrete(*, full_source:, **)
			object = allocate
			object.send(:initialize, *, full_source:, **)
			object
		end

		def self.attr(name, type, **kw)
			prop name, _Union(type, LiteralNil, nil), reader: kw.fetch(:reader, false), default: LiteralNil, **kw
			inspectable name
		end

		def self.token(name, **kw)
			prop name, _Union(Token, LiteralNil, nil), reader: false, default: LiteralNil, **kw

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

				def #{name}_spn
					@#{name}
				end
			RUBY
		end

		def self.node(name, type, **kw)
			attr name, _Nilable(type), reader: :public, **kw
		end

		def self.nodes(name, type, **kw)
			attr name, _Nilable(_Array(type)), reader: :public, **kw
		end
	end
end