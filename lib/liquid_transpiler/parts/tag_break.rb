# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagBreak < Part
      def add(_part)
        error(@offset, 'Internal error')
      end

      def generate(context)
        context.indent(-2).write('break').indent(2)
      end
    end
  end
end
