# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagBreak < Part
      def add(_part)
        error(@offset, 'Internal error')
      end

      def generate(_context, indent, io)
        io.print ' ' * (indent - 2)
        io.puts 'break'
      end
    end
  end
end
