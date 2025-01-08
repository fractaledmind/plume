# frozen_string_literal: true

class Node
	attr_reader :name
	attr_accessor :connections

	def self.[](name) = new(name)

	def initialize(name)
		@name = name
		@connections = Set.new
	end

	def add_connection(node)
		@connections << node
		node
	end
	alias_method :>>, :add_connection

	def inspect
		"Node[#{@name}] >> [#{connections.map(&:name).join(", ")}]"
	end

	def to_s
		repr
	end
end

class TerminalNode < Node
	def repr = "◯"
end

class IdentifierNode < Node
	def repr = "{ #{@name} }"
end

class RuleNode < Node
	def repr = "[ #{@name} ]"
end

class Graph < Node
	attr_reader :nodes, :start_node, :end_node

	def self.[](name)
		instance = new(name)
		yield(instance)
		instance
	end

	def initialize(name)
		@name = name
		@nodes = {}
	end

	def rule(name)
		@nodes[name] ||= RuleNode[name]
	end

	def id(name)
		@nodes[name] ||= IdentifierNode[name]
	end

	def start
		@nodes["START"] ||= TerminalNode["START"]
	end

	def end
		@nodes["END"] ||= TerminalNode["END"]
	end

	def all_paths
		find_all_paths(start, self.end)
	end

	def inspect
		"Graph[#{@name}]\n\t#{all_paths.map { |path| path.join("─▶") }.join("\n\t")}"
	end

	def to_s
		"Graph[#{@name}]"
	end

		private

	def find_all_paths(start, end_node, path = [], values = [])
		path += [start]

		if start == end_node
			return [path]
		end

		paths = []

		start.connections.each do |next_node, value|
			unless path.include?(next_node)
				new_paths = find_all_paths(next_node, end_node, path, values + [value])
				paths.concat(new_paths)
			end
		end

		paths
	end
end

$ordering_term = Graph["ordering-term"] do |graph|
	graph.start >> graph.rule("expr")
	graph.rule("expr") >> graph.end
	graph.rule("expr") >> graph.id("COLLATE")
	graph.rule("expr") >> graph.id("ASC")
	graph.rule("expr") >> graph.id("DESC")
	graph.rule("expr") >> graph.id("NULLS")
	graph.id("COLLATE") >> graph.id("collation-name")
	graph.id("ASC") >> graph.end
	graph.id("ASC") >> graph.id("NULLS")
	graph.id("DESC") >> graph.end
	graph.id("DESC") >> graph.id("NULLS")
	graph.id("NULLS") >> graph.id("FIRST")
	graph.id("NULLS") >> graph.id("LAST")
	graph.id("collation-name") >> graph.end
	graph.id("collation-name") >> graph.id("ASC")
	graph.id("collation-name") >> graph.id("DESC")
	graph.id("collation-name") >> graph.id("NULLS")
	graph.id("FIRST") >> graph.end
	graph.id("LAST") >> graph.end
end

"SELECT SUM() FROM table"

it ""

# ◯─▶[ expr ]─▶{ COLLATE }─▶{ collation-name }─▶{ DESC }─▶{ NULLS }─▶{ FIRST }─▶◯

# ◯─▶[ expr ]┬───────────────▶────────────────┬▶┬──────▶─────┬▶┬──────────▶─────────────┬─▶◯
#            └▶{ COLLATE }─▶{ collation-name }┘ ├▶{ ASC }──▶─┤ ├▶{ NULLS }─▶{ FIRST }─▶─┤
#                                               └▶{ DESC }─▶─┘ └▶{ NULLS }─▶{ LAST }──▶─┘

Graph["aggregate-function-invocation"] do |graph|
	graph.start >> graph.rule("aggregate-func")
	graph.rule("aggregate-func") >> graph.id("(")
	graph.id("(") >> graph.rule("expr")
	graph.rule("expr") >> graph.id("ORDER")
	graph.id("ORDER") >> graph.id("BY")
	graph.id("BY") >> $ordering_term
end

#                              ┌─▶{ DISTINCT }─▶┐ ┌──{ , }◀─┐
# ◯─▶{ aggregate-func }─▶{ ( }─┼────────────────┴▶┴▶[ expr ]┼───────────┬─┬─▶{ ) }┬─────────▶─────────┬─▶◯
#                              │ ┌──────────────────────────┘           │ │       └▶[ filter-clause ]─┘
#                              │ └▶{ ORDER }─▶{ BY }┬▶[ ordering-term ]─┤ │
#                              │                    └───────{ , }◀──────┘ │
#                              └─────────────────┬▶{ * }┬▶────────────────┘
#                                                └───▶──┘

# ┌─┬┐  ╔═╦╗
# │ ││  ║ ║║
# ├─┼┤  ╠═╬╣
# └─┴┘  ╚═╩╝

# ◯─┐
#   └─▶[ expr ]
#      ├─▶◯
#      ├─▶{ COLLATE }
#      │  └─▶{ collation-name }
#      │     ├─▶◯
#      │     ├─▶{ ASC }
#      │     │  ├─▶◯
#      │     │  └─▶{ NULLS }
#      │     │     ├─▶{ FIRST }
#      │     │     │  └─▶◯
#      │     │     └─▶{ LAST }
#      │     │        └─▶◯
#      │     ├─▶{ DESC }
#      │     │  ├─▶◯
#      │     │  └─▶{ NULLS }
#      │     │     ├─▶{ FIRST }
#      │     │     │  └─▶◯
#      │     │     └─▶{ LAST }
#      │     │        └─▶◯
#      │     └─▶{ NULLS }
#      │        ├─▶{ FIRST }
#      │        │  └─▶◯
#      │        └─▶{ LAST }
#      │           └─▶◯
#      ├─▶{ ASC }
#      │  ├─▶◯
#      │  └─▶{ NULLS }
#      │     ├─▶{ FIRST }
#      │     │  └─▶◯
#      │     └─▶{ LAST }
#      │        └─▶◯
#      ├─▶{ DESC }
#      │  ├─▶◯
#      │  └─▶{ NULLS }
#      │     ├─▶{ FIRST }
#      │     │  └─▶◯
#      │     └─▶{ LAST }
#      │        └─▶◯
#      └─▶{ NULLS }
#         ├─▶{ FIRST }
#         │  └─▶◯
#         └─▶{ LAST }
#            └─▶◯
