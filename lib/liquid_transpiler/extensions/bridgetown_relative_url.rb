# frozen_string_literal: true

module LiquidTranspiler
  module Extensions
    class BridgetownRelativeURL
      BASE_PATH = Operators::Dereference.new( Operators::Leaf.new( :bridgetown),'base_path').freeze

      def initialize(expression)
        @expression = expression
      end

      def filter_name
        'relative_url'
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        BASE_PATH.find_arguments(names)
      end

      def generate(context)
        "filter_prepend(#{@expression.generate(context)},#{BASE_PATH.generate(context)})"
      end

      def setup(source)
        source.skip_space
        term = source.get
        if term == ':'
          source.error(source.offset,filter_name+' takes no arguments')
        end
        term
      end
    end
  end
end
