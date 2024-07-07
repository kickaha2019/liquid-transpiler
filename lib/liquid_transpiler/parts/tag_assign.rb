# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagAssign < Part
      def initialize(source, offset, parent)
        super
        @variable = source.expect_name
        source.skip_space
        unless source.next('=')
          source.error(@offset, 'Expecting =')
        end

        @expression, term = Expression.parse(source)
        source.unget term
      end

      def add(_part)
        error(@offset, 'Internal error')
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        names.assign(@variable)
      end

      def generate(context)
        context.write(context.variable(@variable) +
                      " = #{@expression.generate(context)}")
      end
    end
  end
end
