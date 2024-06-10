module LiquidTranspiler
  module Parts
    class TagLiquid < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def setup( source)
        term    = source.get
        context = self

        while term
          part, term = context.parse_tag( source, term)
          context = context.add( part)
        end

        if context != self
          raise TranspilerError.new( @offset, 'Tags inside liquid tag not closed')
        end

        nil
      end
    end
  end
end