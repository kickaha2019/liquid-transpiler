# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagContinue < Part
      def add(part)
        error(@offset, 'Internal error')
      end

      def generate(context, indent, io)
        io.print ' ' * (indent - 2)
        io.puts 'next'
      end
    end
  end
end
