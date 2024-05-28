require_relative 'part'

module LiquidTranspiler
  module Parts
    class Embedded < Part
      def initialize( offset, expression)
        super( offset)
        @expression = expression
      end

      def add( part)
        raise TranspilerError.new( part.offset, 'Internal error')
      end

      def deduce_arguments
        @expression.deduce_arguments
      end

      def generate( arguments, indent, io)
        io.print(' ' * indent)
        io.print arguments[:out]
        io.puts ' << t(' + @expression.generate(arguments) + ')'
      end
    end
  end
end
