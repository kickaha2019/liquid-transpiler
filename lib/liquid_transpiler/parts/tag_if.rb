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

      def generate(context, indent)
        context.write("if #{@expression.generate(context)}").indent(2)
        super(context, indent + 2)
        context.indent(-2).write 'end'
      end
    end
  end
end
