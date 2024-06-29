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

      # rubocop:disable Metrics/MethodLength
      def generate(context, indent)
        context.print ' ' * indent
        for_name = context.tablerow(@variable)
        context.puts "#{for_name}l = tablerow(#{@expression.generate(context)})"

        if @columns
          context.print ' ' * indent
          context.puts "#{for_name}l.columns #{@columns.generate(context)}"
        end

        if @start
          context.print ' ' * indent
          context.puts "#{for_name}l.offset #{@start.generate(context)}"
        end

        if @limit
          context.print ' ' * indent
          context.puts "#{for_name}l.limit #{@limit.generate(context)}"
        end

        context.print ' ' * indent
        context.puts "#{for_name}l.each do |#{for_name}|"

        context.print ' ' * indent
        context.puts "  if #{for_name}l.col_first"
        context.print ' ' * (indent + 4)
        context.print context.output
        context.print ' << "<tr class=\\"row#{'
        context.print "#{for_name}l.row}"
        context.puts '\\">"'
        context.print ' ' * (indent + 4)
        context.print context.output
        context.print ' << "\\n"'
        context.puts "  if #{for_name}l.row == 1"
        context.print ' ' * indent
        context.puts '  end'

        context.print ' ' * (indent + 2)
        context.print context.output
        context.print ' << "<td class=\\"col#{'
        context.print "#{for_name}l.col}"
        context.puts '\\">"'

        super(context, indent + 2)

        context.print ' ' * (indent + 2)
        context.print context.output
        context.puts " << '</td>'"

        context.print ' ' * indent
        context.puts "  if #{for_name}l.col_last || #{for_name}l.last"
        context.print ' ' * (indent + 4)
        context.print context.output
        context.puts ' << "</tr>\\n"'
        context.print ' ' * indent
        context.puts '  end'

        context.print ' ' * indent
        context.puts 'end'

        context.endtablerow(@variable)
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
