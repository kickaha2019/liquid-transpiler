# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToXMLSchema < FilterBase
      TIMEZONE = Operators::Dereference.new( Operators::Leaf.new( :bridgetown),'timezone').freeze

      def filter_name
        'date_to_xmlschema'
      end

      def find_arguments(names)
        super
        TIMEZONE.find_arguments(names)
      end

      def generate(context)
        ['filter_time_strftime(',
         TIMEZONE.generate(context),
         ',',
         @expression.generate(context),
         ',"%Y-%m-%dT%H:%M:%S%:z")'].join ''
      end
    end
  end
end
