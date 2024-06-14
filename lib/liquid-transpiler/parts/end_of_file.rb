module LiquidTranspiler
  module Parts
    class EndOfFile < Part
      def initialize( offset)
        super( offset, nil)
      end

      def add( part)
        raise TranspilerError.new( @offset, 'Internal error')
      end

      def name
        'end of file'
      end
    end
  end
end
