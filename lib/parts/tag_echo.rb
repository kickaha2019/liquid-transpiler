module LiquidTranspiler
  module Parts
    class TagEcho < Part
      def initialize( offset, parent)
        super( offset, parent)
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
        io.puts " << #{@expression.generate(context)}.to_s"
      end

      def setup( source)
        @expression, term = TranspilerExpression.parse( source)
        term
      end
    end
  end
end