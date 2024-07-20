# frozen_string_literal: true

require_relative 'bridgetown_date_to_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToRFC822 < BridgetownDateToBase
      def initialize(expression)
        super
        @arguments << Operators::Leaf.new('%a, %d %b %Y %H:%M:%S %z')
      end

      def filter_name
        'date_to_rfc822'
      end

      def generate(context)
        super(context, 'filter_time_strftime')
      end
    end
  end
end
