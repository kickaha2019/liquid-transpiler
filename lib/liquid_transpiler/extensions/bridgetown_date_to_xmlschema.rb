# frozen_string_literal: true

require_relative 'bridgetown_date_to_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToXMLSchema < BridgetownDateToBase
      def filter_name
        'date_to_xmlschema'
      end

      def generate(context)
        super(context, 'filter_time_strftime')
      end

      def setup(source)
        super.tap do
          @arguments << source.read_object_from_string("'%Y-%m-%dT%H:%M:%S%:z'")
        end
      end
    end
  end
end
