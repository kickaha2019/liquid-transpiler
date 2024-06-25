# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagFor < Part
      def initialize(source, offset, parent)
        super
        @else     = nil
        @limit    = nil
        @reversed = false
        @start    = nil
        @variable = source.expect_name
        token     = source.get

        unless token == :in
          source.error(@offset, 'Expecting in')
        end

        @expression, term = Expression.parse(source)

        loop do
          case term
          when :limit
            @limit, term = Expression.parse_parameter(@offset, source)
          when :reversed
            @reversed = true
            term = source.get
          when :offset
            @start, term = Expression.parse_parameter(@offset, source)
          else
            break
          end
        end

        source.unget term
      end

      def add(part)
        if part.is_a?(TagBreak)
          @children << part
          return self
        end
        if part.is_a?(TagElse)
          @else = part
          return part
        end
        if part.is_a?(TagEndfor)
          return @parent
        end

        super(part)
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        @limit&.find_arguments(names)
        @start&.find_arguments(names)
        names = names.spawn
        names.assign(@variable)
        names.assign(:forloop)
        super(names)
      end

      def generate(context, indent)
        context.print ' ' * indent
        for_name, old_for_loop = context.for(@variable)
        context.puts "#{for_name}l = forloop(#{@expression.generate(context)},#{old_for_loop})"

        if @start
          context.print ' ' * indent
          context.puts "#{for_name}l.offset #{@start.generate(context)}"
        end

        if @limit
          context.print ' ' * indent
          context.puts "#{for_name}l.limit #{@limit.generate(context)}"
        end

        if @reversed
          context.print ' ' * indent
          context.puts "#{for_name}l.reverse"
        end

        if @else
          context.print ' ' * indent
          context.puts "unless #{for_name}l.empty?"
          indent += 2
        end

        context.print ' ' * indent
        context.puts "#{for_name}l.each do |#{for_name}|"
        super(context, indent + 2)
        context.print ' ' * indent
        context.puts 'end'

        if @else
          indent -= 2
          @else.generate(context, indent + 2)
          context.print ' ' * indent
          context.puts 'end'
        end

        context.endfor(@variable)
      end
    end
  end
end
