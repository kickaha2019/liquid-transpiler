module LiquidTranspiler
  module Operators
    class Filter
      def initialize(name, expression, arguments)
        @name       = name
        @expression = expression
        @arguments  = arguments
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        @arguments.each do |argument|
          if argument.is_a?(Parameter)
            argument.value.find_arguments(names)
          else
            argument.find_arguments(names)
          end
        end
      end

      def generate(context)
        options = []
        params  = [@expression.generate(context)]

        @arguments.each do |argument|
          if argument.is_a?(Parameter)
            options << "'#{argument.key}'=>#{argument.value.generate(context)}"
          else
            params << "#{argument.generate(context)}"
          end
        end

        unless options.empty?
          params << "{#{options.join(',')}}"
        end

        "f_#{@name}(#{params.join(',')})"
      end
    end
  end
end
