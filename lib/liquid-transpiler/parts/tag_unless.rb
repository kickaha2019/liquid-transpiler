# frozen_string_literal: true
module LiquidTranspiler
  module Parts
    class TagUnless < Part
      def initialize(source, offset, parent)
        super
        @expression, term = Expression.parse(source)
        source.unget term
      end

      def add(part)
        if part.is_a?(TagEndunless)
          return @parent
        end

        if part.is_a?(TagBreak) || part.is_a?(TagContinue)
          @children << part
          return self
        end
        if part.is_a?(TagElse)
          @children << part
          return part
        end
        super(part)
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        names_unless, names_else = names.spawn, nil

        @children.each do |child|
          if child.is_a?(TagElse)
            names_else = names.spawn
            child.find_arguments(names_else)
          else
            child.find_arguments(names_unless)
          end
        end

        if names_else
          names_unless.locals do |local|
            names.assign(local) if names_else.local?(local)
          end
        end
      end

      def generate(context, indent, io)
        io.print ' ' * indent
        io.puts "unless #{@expression.generate(context)}"
        super(context, indent + 2, io)
        io.print ' ' * indent
        io.puts 'end'
      end
    end
  end
end
