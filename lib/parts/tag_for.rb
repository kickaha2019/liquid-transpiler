module LiquidTranspiler
  module Parts
    class TagFor < Part
      def initialize( offset, parent)
        super( offset, parent)
        @else = nil
      end

      def add( part)
        if part.is_a?( TagBreak)
          @children << part
          return self
        end
        if part.is_a?( TagElse)
          @else = part
          return part
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
        for_name, old_for_loop = context.for( @variable)
        io.puts "#{for_name}l = f(#{@expression.generate( context)},#{old_for_loop})"
        if @else
          io.print ' ' * indent
          io.puts "unless #{for_name}l.empty?"
          indent += 2
        end

        io.print ' ' * indent
        io.puts "#{for_name}l.each do |#{for_name}|"
        super( context, indent+2, io)
        io.print ' ' * indent
        io.puts 'end'

        if @else
          indent -= 2
          @else.generate( context, indent+2, io)
          io.print ' ' * indent
          io.puts "end"
        end

        context.endfor( @variable)
      end

      def setup( source)
        @variable = source.expect_name
        token     = source.get

        unless token == 'in'
          raise TranspilerError.new( @offset, 'Expecting in')
        end

        @expression, term = TranspilerExpression.parse( source)
        return term
      end
    end
  end
end