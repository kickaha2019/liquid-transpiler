module LiquidTranspiler
  module Parts
    class TagFor < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        if part.is_a?( TagEndfor)
          return @parent
        end
        super( part)
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        names = names.spawn
        names.assign( @variable)
        super( names)
      end

      def generate( context, indent, io)
        io.print ' ' * indent
        io.puts "#{@expression.generate( context)}.each do |"
        io.print context.variable( @variable)
        io.puts '|'
        super( context, indent+2, io)
        io.print ' ' * indent
        io.puts 'end'
      end

      def setup( source)
        @variable = source.expect_name
        token     = source.get
        unless token == 'in'
          raise TranspilerError.new( @offset, 'Expecting in')
        end

        @expression, term = TranspilerExpression.parse( source)
        term
      end
    end
  end
end