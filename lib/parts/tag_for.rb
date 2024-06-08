module LiquidTranspiler
  module Parts
    class TagFor < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        if part.is_a?( TagBreak)
          @children << part
          return self
        end
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
        io.print "#{@expression.generate( context)}.each do |"
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

        token = source.get
        if token == '('
          from, type = TranspilerExpression.parse( source)
          unless (type == '..' || type == '...')
            raise TranspilerError.new( @offset, 'Expecting .. or ...')
          end
          to, term = TranspilerExpression.parse( source)
          unless term == ')'
            raise TranspilerError.new( @offset, 'Expecting )')
          end
          term = source.get
          @expression = Operators::Range.new( from, to, type)
        else
          source.unget( token)
          @expression, term = TranspilerExpression.parse( source)
        end

        return term
      end
    end
  end
end