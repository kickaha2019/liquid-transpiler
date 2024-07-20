# frozen_string_literal: true

require_relative 'bridgetown_date_to_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToString < BridgetownDateToBase
      def initialize(expression)
        super
        @arguments.unshift(Operators::Leaf.new('%b'))
      end

      def filter_name
        'date_to_string'
      end

      def generate(context)
        super(context,
              'filter_date_to_string')
      end
    end
  end
end
