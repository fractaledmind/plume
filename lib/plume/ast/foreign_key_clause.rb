# frozen_string_literal: true

module Plume
	class ForeignKeyClause < Node
		Action = _Union(:SET_NULL, :SET_DEFAULT, :CASCADE, :RESTRICT, :NO_ACTION)

		prop :foreign_table, String
		prop :columns, _Nilable(_Array(String))
		prop :on_delete, _Nilable(Action)
		prop :on_update, _Nilable(Action)
		prop :match_name, _Nilable(String)
		prop :deferred, _Nilable(_Boolean)
	end
end
