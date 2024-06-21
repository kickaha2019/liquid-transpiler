# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagIf < Conditional
      def add(part)
        if part.is_a?(TagEndif)
          return @parent
        end

        super(part)
      end

      def generate(context, indent, io)
        io.print ' ' * indent
        io.puts "if #{@expression.generate(context)}"
        super(context, indent + 2, io)
        io.print ' ' * indent
        io.puts 'end'
      end
    end
  end
end
