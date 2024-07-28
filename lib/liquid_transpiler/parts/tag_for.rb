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

        @expression, term = source.expect_expression

        loop do
          case term
          when :limit
            @limit, term = source.read_parameter @offset
          when :reversed
            @reversed = true
            term = source.get
          when :offset
            @start, term = source.read_parameter @offset
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

      def generate(context)
        for_name, old_for_loop = context.for(@variable)
        context.write "#{for_name}l = forloop(#{@expression.generate(context)},#{old_for_loop})"

        if @start
          context.write "#{for_name}l.offset #{@start.generate(context)}"
        end

        if @limit
          context.write "#{for_name}l.limit #{@limit.generate(context)}"
        end

        if @reversed
          context.write "#{for_name}l.reverse"
        end

        if @else
          context.write("unless #{for_name}l.empty?").indent(2)
        end

        context.write("#{for_name}l.each do |#{for_name}|").indent(2)
        super(context)
        context.indent(-2).write 'end'

        if @else
          @else.record(context)
          @else.generate(context)
          context.indent(-2).write 'end'
        end

        context.endfor(@variable)
      end
    end
  end
end
