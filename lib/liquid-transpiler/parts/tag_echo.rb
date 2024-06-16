module LiquidTranspiler
  module Parts
    class TagEcho < Part
      def initialize(source, offset, parent)
        super
        @expression, term = Expression.parse(source)
        source.unget term
      end

      def add(part)
        error(part.offset, 'Internal error')
      end

      def find_arguments(names)
        @expression.find_arguments(names)
      end

      def generate(context, indent, io)
        io.print(' ' * indent)
        io.print context.output
        io.puts " << #{@expression.generate(context)}.to_s"
      end
    end
  end
end
