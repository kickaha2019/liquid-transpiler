module LiquidTranspiler
  module Parts
    class TagUnless < Part
      def add( part)
        if part.is_a?( TagBreak) || part.is_a?( TagContinue)
          @children << part
          return self
        end
        if part.is_a?( TagElse)
          @children << part
          return part
        end
        if part.is_a?( TagEndunless)
          return @parent
        end
        super( part)
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        names_if, names_else = names.spawn, nil

        @children.each do |child|
          if child.is_a?( TagElse)
            names_else = names.spawn
            child.find_arguments( names_else)
          else
            child.find_arguments( names_if)
          end
        end

        if names_else
          names_if.locals do |local|
            names.assign( local) if names_else.local?( local)
          end
        end
      end

      def generate( context, indent, io)
        io.print ' ' * indent
        io.puts "unless #{@expression.generate( context)}"
        super( context, indent+2, io)
        io.print ' ' * indent
        io.puts 'end'
      end

      def setup( source)
        @expression, term = Expression.parse( source)
        term
      end
    end
  end
end