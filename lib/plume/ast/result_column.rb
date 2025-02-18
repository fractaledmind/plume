# frozen_string_literal: true

module Plume
	class ResultColumn < Node
		prop :result, Expression
		prop :alias, _Nilable(String)
	end
end
