# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownWhereExp < FilterBase
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

      def setup(source)
        source.skip_space
        source.error(source.offset, 'Expecting :') unless source.next(':')
        @variable = source.expect_literal.to_sym

        source.skip_space
        source.error(source.offset, 'Expecting ,') unless source.next(',')
        nested = source.expect_nested_source

        @clause, term = LiquidTranspiler::Expression.parse1(nested)
        source.error(source.offset, 'Bad where clause') unless term.nil?
        source.get
      end
    end
  end
end
