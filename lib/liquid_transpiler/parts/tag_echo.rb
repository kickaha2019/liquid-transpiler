# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagEcho < Part
      def initialize(source, offset, parent)
        super
        @expression, term = source.expect_expression
        source.unget term
      end

      def add(part)
        error(part.offset, 'Internal error')
      end

      def find_arguments(names)
        @expression.find_arguments(names)
      end

      def generate(context)
        context.write_output("#{@expression.generate(context)}.to_s")
      end
    end
  end
end
