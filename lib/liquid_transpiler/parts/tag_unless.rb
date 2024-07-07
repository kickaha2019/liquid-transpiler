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

      def generate(context)
        context.write("unless #{@expression.generate(context)}").indent(2)
        super(context)
        context.indent(-2).write 'end'
      end
    end
  end
end
