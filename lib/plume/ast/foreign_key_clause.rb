# frozen_string_literal: true

module Plume
	class ForeignKeyClause < Node
		TOKEN_TO_DEFERRABLE = {
			:DEFERRABLE                                        => false,
			[:DEFERRABLE].freeze                               => false,
			[:NOT, :DEFERRABLE].freeze                         => false,
			[:DEFERRABLE, :INITIALLY, :DEFERRED].freeze        => true,
			[:DEFERRABLE, :INITIALLY, :IMMEDIATE].freeze       => false,
			[:NOT, :DEFERRABLE, :INITIALLY, :DEFERRED].freeze  => false,
			[:NOT, :DEFERRABLE, :INITIALLY, :IMMEDIATE].freeze => false,
		}.freeze
		Deferrable = _Union(TOKEN_TO_DEFERRABLE.values)

		required_token :references_kw
		required_token :table_tk,
			reader: :table,
			default: -> { table_tk_val }
		optional_token :columns_lp
		optional_nodes :columns, IndexedColumn
		optional_token :columns_rp
		optional_nodes :actions, ForeignKeyAction
		optional_nodes :match_clauses, MatchClause
		optional_token :deferrable_span,
			reader: :deferred,
			type: Deferrable,
			default: -> { TOKEN_TO_DEFERRABLE[deferrable_span_tok] }

		def on_delete
			actions.reverse_each do |it|
				return it.action if it.trigger == :DELETE
			end
		end

		def on_update
			actions.reverse_each do |it|
				return it.action if it.trigger == :UPDATE
			end
		end

		def match_type
			match_clauses.last.type
		end
	end
end
