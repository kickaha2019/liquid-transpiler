# frozen_string_literal: true

require_relative 'bridgetown_date_to_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToLongString < BridgetownDateToBase
      def filter_name
        'date_to_long_string'
      end

      def generate(context)
        super(context,
              'filter_date_to_string')
      end

      def setup(source)
        @arguments << source.read_object_from_string("'%B'")
        super
      end
    end
  end
end
