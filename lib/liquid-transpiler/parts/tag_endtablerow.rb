# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagEndtablerow < Part
      def add(_part)
        error(@offset, 'Internal error')
      end
    end
  end
end
