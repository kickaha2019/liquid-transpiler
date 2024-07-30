# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownWhereExp < FilterBase
      def initialize(expression, parser)
        @expression = expression
        parser.skip_space
        parser.error(parser.offset, 'Expecting :') unless parser.next_string?(':')
        @variable = parser.expect_literal.to_sym

        parser.skip_space
        parser.error(parser.offset, 'Expecting ,') unless parser.next_string?(',')

        @clause = parser.read_object_from_string(parser.expect_literal)
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        names = names.spawn
        names.assign(@variable)
        @clause.find_arguments(names)
      end

      def generate(context)
        temporary = context.temporary
        context.write "#{temporary} = []"
        for_name, = context.for(@variable)
        loop = <<~LOOP
          to_array(#{@expression.generate(context)}).each do |#{for_name}|
        LOOP
        context.write(loop).indent 2
        context.write "if #{@clause.generate(context)}"
        context.indent(2).write("#{temporary} << #{for_name}").indent(-2)
        context.write 'end'
        context.indent(-2).write 'end'
        context.endfor(@variable)
        temporary
      end
    end
  end
end
