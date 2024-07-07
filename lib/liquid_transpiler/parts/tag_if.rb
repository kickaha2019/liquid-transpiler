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

      def generate(context)
        context.write("if #{@expression.generate(context)}").indent(2)
        super(context)
        context.indent(-2).write 'end'
      end
    end
  end
end
