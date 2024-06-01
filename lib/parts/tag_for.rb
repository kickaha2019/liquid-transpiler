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
        @children << part
        clazz = part.class.name.split('::')[-1]

        case clazz
        when 'Embedded'
          return self
        when 'EndOfFile'
          raise TranspilerError.new( part.offset, 'Unexpected EOF')
        when 'TagAssign'
          return self
        when 'TagFor'
          return part
        else
          raise TranspilerError.new( part.offset, 'Unexpected tag')
        end
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        names = names.spawn
        names.assign( @variable)
        @children.each do |child|
          child.find_arguments( names)
        end
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