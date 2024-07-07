# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagTablerow < Part
      def initialize(source, offset, parent)
        super
        @columns  = nil
        @limit    = nil
        @start    = nil
        @variable = source.expect_name
        token     = source.get

        unless token == :in
          source.error(@offset, 'Expecting in')
        end

        @expression, term = Expression.parse(source)

        loop do
          case term
          when :cols
            @columns, term = Expression.parse_parameter(@offset, source)
          when :limit
            @limit, term = Expression.parse_parameter(@offset, source)
          when :offset
            @start, term = Expression.parse_parameter(@offset, source)
          else
            break
          end
        end

        source.unget term
      end

      def add(part)
        if part.is_a?(TagEndtablerow)
          return @parent
        end

        super(part)
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        @columns&.find_arguments(names)
        @limit&.find_arguments(names)
        @start&.find_arguments(names)
        names = names.spawn
        names.assign(@variable)
        names.assign(:tablerowloop)
        super(names)
      end

      def generate(context)
        for_name = context.tablerow(@variable)
        context.write "#{for_name}l = tablerow(#{@expression.generate(context)})"

        if @columns
          context.write "#{for_name}l.columns #{@columns.generate(context)}"
        end

        if @start
          context.write "#{for_name}l.offset #{@start.generate(context)}"
        end

        if @limit
          context.write "#{for_name}l.limit #{@limit.generate(context)}"
        end

        context.write("#{for_name}l.each do |#{for_name}|").indent(2)
        context.write("if #{for_name}l.col_first").indent(2)

        tr = ['"<tr class=\\"row#{',
              "#{for_name}l.row}",
              '\\">"']
        context.write_output tr.join('')

        context.write_output('"\\n" ' + "if #{for_name}l.row == 1")
        context.indent(-2).write 'end'

        td = ['"<td class=\\"col#{', "#{for_name}l.col}", '\\">"']
        context.write_output td.join('')

        super(context)

        context.write_output "'</td>'"

        context.write("if #{for_name}l.col_last || #{for_name}l.last").indent(2)
        context.write_output('"</tr>\\n"')
        context.indent(-2).write('end')

        context.indent(-2).write('end')

        context.endtablerow(@variable)
      end
    end
  end
end
