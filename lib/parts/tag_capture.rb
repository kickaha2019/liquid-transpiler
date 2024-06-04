module LiquidTranspiler
  module Parts
    class TagCapture < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        if part.is_a?( TagEndcapture)
          return @parent
        end
        super( part)
      end

      def find_arguments( names)
        super( names)
        names.assign( @variable)
      end

      def generate( context, indent, io)
        context.output_push
        io.print ' ' * indent
        io.print context.output
        io.puts " = []"
        super( context, indent, io)
        io.print ' ' * indent
        io.print context.variable( @variable)
        io.puts " = #{context.output}.join('')"
        context.output_pop
      end

      def setup( source)
        @variable = source.expect_name
        source.get
      end
    end
  end
end