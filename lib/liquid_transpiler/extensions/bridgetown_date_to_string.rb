# frozen_string_literal: true

require_relative 'bridgetown_date_to_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToString < BridgetownDateToBase
      def initialize(expression, parser)
        super
        @arguments.unshift parser.read_object_from_string("'%b'")
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
