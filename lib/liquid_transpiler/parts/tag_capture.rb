# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagCapture < Part
      def initialize(source, offset, parent)
        super
        @variable = source.expect_name
      end

      def add(part)
        if part.is_a?(TagEndcapture)
          return @parent
        end

        super(part)
      end

      def find_arguments(names)
        super(names)
        names.assign(@variable)
      end

      def generate(context, indent)
        context.output_push
        context.write(context.output + ' = []')
        super(context, indent)
        context.write(context.variable(@variable) + " = #{context.output}.join('')")
        context.output_pop
      end
    end
  end
end
