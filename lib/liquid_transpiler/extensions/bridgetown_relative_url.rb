# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownRelativeURL < FilterBase
      def find_arguments(names)
        @expression.find_arguments(names)
        @base_path.find_arguments(names)
      end

      def generate(context)
        "filter_prepend(#{@expression.generate(context)},#{@base_path.generate(context)})"
      end

      def setup(source)
        @base_path = source.read_object_from_string('bridgetown.base_path')
        super
      end
    end
  end
end
