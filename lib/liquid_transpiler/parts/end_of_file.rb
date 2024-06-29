# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class EndOfFile < Part
      def add(_part)
        error(@offset, 'Internal error')
      end

      def name
        'end of file'
      end
    end
  end
end
