# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagWhen < Part
      def initialize(source, offset, parent)
        super
        @expression, term = Expression.parse(source)
        source.unget term
      end

      def add(part)
        if part.is_a?(TagWhen) || part.is_a?(TagElse) || part.is_a?(TagEndcase)
          return @parent.add(part)
        end

        super(part)
      end

      def generate(context, indent)
        context.indent(-2).write("when #{@expression.generate(context)}").indent(2)
        super(context, indent)
      end
    end
  end
end
