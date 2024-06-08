module LiquidTranspiler
  module Parts
    class TagElse < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        if part.is_a?( TagBreak)
          @children << part
          return self
        end
        if part.is_a?( TagEndcase) || part.is_a?( TagEndif)
          return @parent.add( part)
        end
        super( part)
      end

      def generate( context, indent, io)
        io.print ' ' * (indent - 2)
        io.puts "else"
        super( context, indent, io)
      end

      def setup( source)
      end
    end
  end
end