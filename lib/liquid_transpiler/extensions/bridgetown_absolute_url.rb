# frozen_string_literal: true

require_relative 'bridgetown_relative_url'

module LiquidTranspiler
  module Extensions
    class BridgetownAbsoluteURL < BridgetownRelativeURL
      def initialize(expression, parser)
        super
        @url = parser.read_object_from_string('bridgetown.url')
      end

      def find_arguments(names)
        super
        @url.find_arguments(names)
      end

      def generate(context)
        "filter_prepend(#{super(context)},#{@url.generate(context)})"
      end
    end
  end
end
