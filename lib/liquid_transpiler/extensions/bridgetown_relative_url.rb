# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownRelativeURL < FilterBase
      def initialize(expression, parser)
        super
        @base_path = parser.read_object_from_string('bridgetown.base_path')
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        @base_path.find_arguments(names)
      end

      def generate(context)
        "filter_prepend(#{@expression.generate(context)},#{@base_path.generate(context)})"
      end
    end
  end
end
