# frozen_string_literal: true

require_relative 'part'

module LiquidTranspiler
  module Parts
    class Conditional < Part
      def initialize(source, offset, parent)
        super
        @expression, term = source.expect_expression
        source.unget term
      end

      def add(part)
        if part.is_a?(TagBreak) || part.is_a?(TagContinue)
          @children << part
          return self
        end

        if part.is_a?(TagElse)
          @children << part
          return part
        end

        super(part)
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        names_if, names_else = names.spawn, nil

        @children.each do |child|
          if child.is_a?(TagElse)
            names_else = names.spawn
            child.find_arguments(names_else)
          else
            child.find_arguments(names_if)
          end
        end

        if names_else
          names_if.locals do |local|
            names.assign(local) if names_else.local?(local)
          end
        end
      end
    end
  end
end
