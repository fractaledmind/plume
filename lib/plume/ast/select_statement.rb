# frozen_string_literal: true

module Plume
	#
	# **[SQLite Docs](https://www.sqlite.org/lang_select.html)**
	#
	# ```sql
	#
	# ```
	class SelectStatement < Node
		prop :type, _Void
		prop :columns, _Void
		prop :from, _Void
		prop :where, _Void
		prop :group_by, _Void
		prop :having, _Void
		prop :window, _Void
		prop :compound, _Void
		prop :order_by, _Void
		prop :limit, _Void
		prop :offset, _Void
	end
end
