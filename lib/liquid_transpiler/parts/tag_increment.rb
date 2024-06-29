# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagIncrement < Part
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

      def generate(context, indent)
        variable = context.increment(@name)
        context.print(' ' * indent)
        context.print context.output
        context.puts " << #{variable}.to_s"
        context.print ' ' * indent
        context.puts "#{variable} += 1"
      end
    end
  end
end
