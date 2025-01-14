# frozen_string_literal: true

module Plume
	class Blob < Node
		prop :blob, _Union(
			IO,
			proc { |it| StringIO === it if defined?(StringIO) }
		)
	end
end
