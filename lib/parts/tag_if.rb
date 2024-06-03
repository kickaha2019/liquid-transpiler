module LiquidTranspiler
  module Parts
    class TagIf < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        if part.is_a?( TagEndif)
          return @parent
        end
        super( part)
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        names = names.spawn
        @children.each do |child|
          child.find_arguments( names)
        end
      end

      def generate( context, indent, io)
        io.print ' ' * indent
        io.puts "if #{@expression.generate( context)}"
        super( context, indent+2, io)
        io.print ' ' * indent
        io.puts 'end'
      end

      def setup( source)
        @expression, term = TranspilerExpression.parse( source)
        term
      end
    end
  end
end