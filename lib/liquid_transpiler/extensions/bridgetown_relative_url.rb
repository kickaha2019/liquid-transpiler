# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownRelativeURL < FilterBase
      BASE_PATH = Operators::Dereference.new( Operators::Leaf.new( :bridgetown),
                                              'base_path').freeze

      def find_arguments(names)
        @expression.find_arguments(names)
        BASE_PATH.find_arguments(names)
      end

      def generate(context)
        "filter_prepend(#{@expression.generate(context)},#{BASE_PATH.generate(context)})"
      end
    end
  end
end
