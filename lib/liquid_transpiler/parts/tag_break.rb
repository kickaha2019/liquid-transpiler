# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagBreak < Part
      def add(_part)
        error(@offset, 'Internal error')
      end

      def generate(context, indent)
        context.print ' ' * (indent - 2)
        context.puts 'break'
      end
    end
  end
end
