# frozen_string_literal: true

require_relative 'part'

module LiquidTranspiler
  module Parts
    class Embedded < Part
      def initialize(source, offset, expression)
        super(source, offset, nil)
        @expression = expression
      end

      def add(part)
        error(part.offset, 'Internal error')
      end

      def find_arguments(names)
        @expression.find_arguments(names)
      end

      def generate(context)
        context.write_output("to_string(#{@expression.generate(context)})")
      end

      def name
        '{{ ... }}'
      end
    end
  end
end
