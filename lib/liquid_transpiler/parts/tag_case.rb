# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagCase < Part
      def initialize(source, offset, parent)
        super
        @expression, term = source.expect_expression
        source.unget term
      end

      # rubocop:disable Style/CaseLikeIf
      def add(part)
        if part.is_a?(TagWhen) || part.is_a?(TagElse)
          @children << part
          part
        elsif part.is_a?(TagEndcase)
          @parent
        elsif part.is_a?(Text)
          part.strip
          unless part.empty?
            error(part.offset, "Unexpected #{part.name}")
          end
        else
          error(part.offset, "Unexpected #{part.name}")
        end
      end
      # rubocop:enable Style/CaseLikeIf

      def find_arguments(names)
        @expression.find_arguments(names)
        sub_names = []

        @children.each do |child|
          if child.is_a?(TagWhen) || child.is_a?(TagElse)
            sub_names << names.spawn
            child.find_arguments(sub_names[-1])
          elsif child.is_a?(Text)
            child.strip
            unless child.empty?
              error(offset, 'Unexpected text after case tag')
            end
          else
            error(child.offset, "Unexpected #{child.name}")
          end
        end

        if @children[-1].is_a?(TagElse)
          possible = []

          sub_names[0].locals { |name| possible << name }
          sub_names[1..].each do |child|
            last, possible = possible, []
            last.each do |name|
              possible << name if child.local?(name)
            end
          end

          possible.each do |name|
            names.assign(name)
          end
        end
      end

      def generate(context)
        context.write("case #{@expression.generate(context)}").indent(2)
        super(context)
        context.indent(-2).write('end')
      end
    end
  end
end
