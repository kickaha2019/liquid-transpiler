module LiquidTranspiler
  module Operators
    class Dereference
      def initialize( expression, field)
        @expression = expression
        @field      = field
      end

      def find_arguments( names)
        @expression.find_arguments( names)
      end

      def generate( context)
        case @field
        when 'first'
          "f_first(#{@expression.generate(context)})"
        when 'last'
          "f_last(#{@expression.generate(context)})"
        when 'size'
          "f_size(#{@expression.generate(context)})"
        else
          "x(#{@expression.generate(context)},'#{@field}')"
        end
      end
    end
  end
end
