# frozen_string_literal: true

module Plume
	class CaseCondition < Node
		token :when_kw
		token :predicate_tk
		token :then_kw
		token :consequence_tk

		attr :predicate, Expression
		attr :consequence, Expression

		def self.new(*, predicate:, consequence:, **) = super
		def self.concrete(*, when_kw:, then_kw:, **) = super

		# Parser may pass either tokens or attributes, so
		# require none in `concrete` signature but ensure presence here.
		def after_initialize()
			if @predicate.nil? && @predicate_tk.nil?
				raise ArgumentError.new("missing either: :predicate, :predicate_tk")
			elsif @consequence.nil? && @consequence_tk.nil?
				raise ArgumentError.new("missing either: :consequence, :consequence_tk")
			end
		end

		def predicate = @predicate || predicate_tk_val
		def consequence = @consequence || consequence_tk_val
	end
end
