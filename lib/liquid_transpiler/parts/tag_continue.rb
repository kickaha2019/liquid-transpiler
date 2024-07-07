# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagContinue < Part
      def add(_part)
        error(@offset, 'Internal error')
      end

      def generate(context, indent)
        context.indent(-2).write('next').indent(2)
      end
    end
  end
end
