# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagDecrement < Part
      def initialize(source, offset, parent)
        super
        @name = source.expect_name
      end

      def add(part)
        error(part.offset, 'Internal error')
      end

      def find_arguments(names)
        names.increment(@name)
      end

      def generate(context)
        variable = context.increment(@name)
        context.write("#{variable} -= 1")
        context.write_output("#{variable}.to_s")
      end
    end
  end
end
