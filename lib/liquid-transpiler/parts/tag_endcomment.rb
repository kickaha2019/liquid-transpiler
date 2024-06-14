module LiquidTranspiler
  module Parts
    class TagEndcomment < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def add( part)
        raise TranspilerError.new( @offset, 'Internal error')
      end
    end
  end
end