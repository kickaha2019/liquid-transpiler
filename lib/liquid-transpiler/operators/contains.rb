# frozen_string_literal: true
module LiquidTranspiler
  module Operators
    class Contains
      def initialize(text, search)
        @text   = text
        @search = search
      end

      def find_arguments(names)
        @text.find_arguments(names)
        @search.find_arguments(names)
      end

      def generate(context)
        "o_contains(#{@text.generate(context)}, #{@search.generate(context)})"
      end
    end
  end
end
