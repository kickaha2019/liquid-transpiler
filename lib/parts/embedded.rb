require_relative 'part'

module LiquidTranspiler
  module Parts
    class Embedded < Part
      def initialize( offset, expression)
        super( offset, nil)
        @expression = expression
      end

      def add( part)
        raise TranspilerError.new( part.offset, 'Internal error')
      end

      def find_arguments( names)
        @expression.find_arguments( names)
      end

      def generate( context, indent, io)
        io.print(' ' * indent)
        io.print context.output
        io.puts ' << t(' + @expression.generate(context) + ')'
      end
    end
  end
end
