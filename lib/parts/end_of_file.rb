module LiquidTranspiler
  module Parts
    class EndOfFile < Part
      def initialize( offset)
        super( offset, nil)
      end
    end
  end
end
