module LiquidTranspiler
  module Parts
    class EndOfFile < Part
      def add( part)
        error( @offset, 'Internal error')
      end

      def name
        'end of file'
      end
    end
  end
end
