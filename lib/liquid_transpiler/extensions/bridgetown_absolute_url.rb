# frozen_string_literal: true

require_relative 'bridgetown_relative_url'

module LiquidTranspiler
  module Extensions
    class BridgetownAbsoluteURL < BridgetownRelativeURL
      def find_arguments(names)
        super
        @url.find_arguments(names)
      end

      def generate(context)
        "filter_prepend(#{super(context)},#{@url.generate(context)})"
      end

      def setup(source)
        @url = source.read_object_from_string('bridgetown.url')
        super
      end
    end
  end
end
