# frozen_string_literal: true

module LiquidTranspiler
  module Operators
    class Range
      def initialize(from, to, type)
        @from = from
        @to   = to
        @type = type
      end

      def find_arguments(names)
        @from.find_arguments(names)
        @to.find_arguments(names)
      end

      def generate(context)
        "(#{@from.generate(context)}#{@type}#{@to.generate(context)})"
      end
    end
  end
end
