# frozen_string_literal: true

module Plume
	#
	# **[SQLite Docs](https://www.sqlite.org/lang_select.html)**
	#
	# ```sql
	#
	# ```
	class SelectStatement < Node
		token :select_kw
		token :type_tk
		token :from_kw
		token :where_kw
		token :group_by_kw
		token :having_kw
		token :window_kw

		nodes :columns, _Any
		node :source, _Any
		node :condition, _Any
		nodes :groupings, _Any
		node :having, _Any
		nodes :windows, _Any

		def self.new(*, **) = super
		def self.concrete(*, **) = super
	end
end
