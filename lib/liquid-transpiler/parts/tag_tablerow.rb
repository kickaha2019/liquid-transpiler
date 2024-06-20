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
      def generate(context, indent, io)
        io.print ' ' * indent
        for_name = context.tablerow(@variable)
        io.puts "#{for_name}l = tablerow(#{@expression.generate(context)})"

        if @columns
          io.print ' ' * indent
          io.puts "#{for_name}l.columns #{@columns.generate(context)}"
        end

        if @start
          io.print ' ' * indent
          io.puts "#{for_name}l.offset #{@start.generate(context)}"
        end

        if @limit
          io.print ' ' * indent
          io.puts "#{for_name}l.limit #{@limit.generate(context)}"
        end

        io.print ' ' * indent
        io.puts "#{for_name}l.each do |#{for_name}|"

        io.print ' ' * indent
        io.puts "  if #{for_name}l.col_first"
        io.print ' ' * (indent + 4)
        io.print context.output
        io.print ' << "<tr class=\\"row#{'
        io.print "#{for_name}l.row}"
        io.puts '\\">"'
        io.print ' ' * (indent + 4)
        io.print context.output
        io.print ' << "\\n"'
        io.puts "  if #{for_name}l.row == 1"
        io.print ' ' * indent
        io.puts '  end'

        io.print ' ' * (indent + 2)
        io.print context.output
        io.print ' << "<td class=\\"col#{'
        io.print "#{for_name}l.col}"
        io.puts '\\">"'

        super(context, indent + 2, io)

        io.print ' ' * (indent + 2)
        io.print context.output
        io.puts " << '</td>'"

        io.print ' ' * indent
        io.puts "  if #{for_name}l.col_last || #{for_name}l.last"
        io.print ' ' * (indent + 4)
        io.print context.output
        io.puts ' << "</tr>\\n"'
        io.print ' ' * indent
        io.puts '  end'

        io.print ' ' * indent
        io.puts 'end'

        context.endtablerow(@variable)
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
