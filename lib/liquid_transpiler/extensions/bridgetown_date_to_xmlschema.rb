# frozen_string_literal: true

module LiquidTranspiler
  module Extensions
    class BridgetownDateToXMLSchema
      TIMEZONE = Operators::Dereference.new( Operators::Leaf.new( :bridgetown),'timezone').freeze

      def initialize(expression)
        @expression = expression
      end

      def filter_name
        'date_to_xmlschema'
      end

      def find_arguments(names)
        @expression.find_arguments(names)
        TIMEZONE.find_arguments(names)
      end

      def generate(context)
        ['filter_time_strftime(',
         TIMEZONE.generate(context),
         ',',
         @expression.generate(context),
         ',"%Y-%m-%dT%H:%M:%S%:z")'].join ''
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
