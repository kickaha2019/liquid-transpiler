module LiquidTranspiler
  module Parts
    class TagCase < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        if part.is_a?( TagWhen) || part.is_a?( TagElse)
          @children << part
          part
        elsif part.is_a?( TagEndcase)
          @parent
        else
          raise TranspilerError.new( part.offset,
                                     'Unexpected ' + part.name)
        end
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        sub_names = []

        @children.each do |child|
          if child.is_a?( TagWhen) || child.is_a?( TagElse)
            sub_names << names.spawn
            child.find_arguments( sub_names[-1])
          elsif child.is_a?( Text)
            child.strip
            unless child.empty?
              raise TranspilerError.new( part.offset,
                                         'Unexpected text after case tag')
            end
          else
            raise TranspilerError.new( child.offset,
                                       'Unexpected ' + child.name)
          end
        end

        if @children[-1].is_a?( TagElse)
          possible = []

          sub_names[0].locals {|name| possible << name}
          sub_names[1..-1].each do |child|
            last, possible = possible, []
            possible.each do |name|
              possible << name if child.local?( name)
            end
          end

          possible.each do |name|
            names.assign( name)
          end
        end
      end

      def generate( context, indent, io)
        io.print ' ' * indent
        io.puts "case #{@expression.generate( context)}"
        super( context, indent, io)
        io.print ' ' * indent
        io.puts 'end'
      end

      def setup( source)
        @expression, term = TranspilerExpression.parse( source)
        term
      end
    end
  end
end