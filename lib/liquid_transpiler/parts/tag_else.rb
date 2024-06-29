# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagElse < Part
      def add(part)
        if part.is_a?(TagBreak) || part.is_a?(TagContinue)
          @children << part
          return self
        end
        if part.is_a?(TagEndcase) ||
           part.is_a?(TagEndfor) ||
           part.is_a?(TagEndif) ||
           part.is_a?(TagEndunless)
          return @parent.add(part)
        end

        super(part)
      end

      def generate(context, indent)
        context.print ' ' * (indent - 2)
        context.puts 'else'
        super(context, indent)
      end
    end
  end
end
