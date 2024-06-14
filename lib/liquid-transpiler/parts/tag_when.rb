module LiquidTranspiler
  module Parts
    class TagWhen < Part
      def add( part)
        if part.is_a?( TagWhen) || part.is_a?( TagElse) || part.is_a?( TagEndcase)
          return @parent.add( part)
        end
        super( part)
      end

      def generate( context, indent, io)
        io.print ' ' * (indent - 2)
        io.puts "when #{@expression.generate( context)}"
        super( context, indent, io)
      end

      def setup( source)
        @expression, term = Expression.parse( source)
        term
      end
    end
  end
end