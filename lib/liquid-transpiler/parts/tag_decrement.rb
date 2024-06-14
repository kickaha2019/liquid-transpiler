module LiquidTranspiler
  module Parts
    class TagDecrement < Part
      def add( part)
        error( part.offset, 'Internal error')
      end

      def find_arguments( names)
        names.increment(@name)
      end

      def generate( context, indent, io)
        variable = context.increment(@name)
        io.print ' ' * indent
        io.puts "#{variable} -= 1"
        io.print(' ' * indent)
        io.print context.output
        io.puts " << #{variable}.to_s"
      end

      def setup( source)
        @name = source.expect_name
        source.get
      end
    end
  end
end