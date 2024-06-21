# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagUnless < Conditional
      def add(part)
        if part.is_a?(TagEndunless)
          return @parent
        end

        super(part)
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
