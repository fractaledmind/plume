# frozen_string_literal: true

module Plume
	class Type < Node
		prop :name, String
		prop :constraints, _Nilable(
			_Constraint(
				_Array(SignedNumber),
				size: 0..2
			)
		)
	end
end
