# frozen_string_literal: true

module LiquidTranspiler
  module Operators
    class Equals
      def initialize(left, right)
        @left  = left
        @right = right
      end

      def find_arguments(names)
        @left.find_arguments(names)
        @right.find_arguments(names)
      end

      def generate(context)
        "operator_eq(#{@left.generate(context)},#{@right.generate(context)})"
      end
    end
  end
end
