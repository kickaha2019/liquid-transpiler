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

      def generate(context, indent, io)
        context.output_push
        io.print ' ' * indent
        io.print context.output
        io.puts ' = []'
        super(context, indent, io)
        io.print ' ' * indent
        io.print context.variable(@variable)
        io.puts " = #{context.output}.join('')"
        context.output_pop
      end
    end
  end
end
