# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToRFC822 < FilterBase
      TIMEZONE = Operators::Dereference.new( Operators::Leaf.new( :bridgetown),'timezone').freeze

      def find_arguments(names)
        super
        TIMEZONE.find_arguments(names)
      end

      def generate(context)
        ['filter_time_strftime(',
         TIMEZONE.generate(context),
         ',',
         @expression.generate(context),
         ',"%a, %d %b %Y %H:%M:%S %z")'].join ''
      end
    end
  end
end
