# frozen_string_literal: true

require_relative 'filter_base'

module LiquidTranspiler
  module Extensions
    class BridgetownDateToBase < FilterBase
      def find_arguments(names)
        super
        @timezone.find_arguments(names)
      end

      def generate(context, filter)
        arguments = @arguments.collect do |argument|
          argument.generate(context)
        end
        [filter,
         '(',
         @timezone.generate(context),
         ',',
         @expression.generate(context),
         ',',
         arguments.join(','),
         ')'].join ''
      end

      def setup(source)
        @timezone = source.read_object_from_string('bridgetown.timezone')
        super
      end
    end
  end
end
