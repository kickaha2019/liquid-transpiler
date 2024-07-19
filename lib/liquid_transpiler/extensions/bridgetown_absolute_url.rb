# frozen_string_literal: true

require_relative 'bridgetown_relative_url'

module LiquidTranspiler
  module Extensions
    class BridgetownAbsoluteURL < BridgetownRelativeURL
      URL = Operators::Dereference.new( Operators::Leaf.new( :bridgetown),
                                        'url').freeze

      def find_arguments(names)
        super
        URL.find_arguments(names)
      end

      def generate(context)
        "filter_prepend(#{super(context)},#{URL.generate(context)})"
      end
    end
  end
end
