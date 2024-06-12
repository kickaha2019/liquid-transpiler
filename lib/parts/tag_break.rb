module LiquidTranspiler
  module Parts
    class TagBreak < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        raise TranspilerError.new( @offset, 'Internal error')
      end

      def generate( context, indent, io)
        io.print ' ' * (indent - 2)
        io.puts "break"
      end
    end
  end
end