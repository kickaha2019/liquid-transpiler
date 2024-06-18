# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagEndcase < Part
      def add(_part)
        error(@offset, 'Internal error')
      end
    end
  end
end
