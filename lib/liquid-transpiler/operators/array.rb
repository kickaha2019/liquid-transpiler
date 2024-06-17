# frozen_string_literal: true
module LiquidTranspiler
  module Operators
    class Array
      def initialize(base, index)
        @base  = base
        @index = index
      end

      def find_arguments(names)
        @base.find_arguments(names)
        @index.find_arguments(names)
      end

      def generate(context)
        "#{@base.generate(context)}[#{@index.generate(context)}]"
      end
    end
  end
end
