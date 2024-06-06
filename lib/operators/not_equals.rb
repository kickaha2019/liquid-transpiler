module LiquidTranspiler
  module Operators
    class NotEquals
      def initialize( left, right)
        @left  = left
        @right = right
      end

      def find_arguments( names)
        @left.find_arguments( names)
        @right.find_arguments( names)
      end

      def generate( context)
        "o_ne(#{@left.generate(context)},#{@right.generate(context)})"
      end
    end
  end
end
