module LiquidTranspiler
  module Operators
    class Filter
      def initialize( name, expression, arguments)
        @name       = name
        @expression = expression
        @arguments  = arguments
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        @arguments.each do |argument|
          argument.find_arguments( names)
        end
      end

      def generate( context)
        params = [@expression.generate(context)]
        @arguments.each do |argument|
          params << ",#{argument.generate(context)}"
        end
        "f_#{@name}(#{params.join(',')})"
      end
    end
  end
end
