# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToBase < FilterBase
      TIMEZONE = Operators::Dereference.new(Operators::Leaf.new(:bridgetown), 'timezone').freeze

      def find_arguments(names)
        super
        TIMEZONE.find_arguments(names)
      end

      def generate(context, filter)
        arguments = @arguments.collect do |argument|
          argument.generate(context)
        end
        [filter,
         '(',
         TIMEZONE.generate(context),
         ',',
         @expression.generate(context),
         ',',
         arguments.join(','),
         ')'].join ''
      end
    end
  end
end
