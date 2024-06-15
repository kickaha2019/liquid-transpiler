module LiquidTranspiler
  module Parts
    class TagLiquid < Part
      def setup( source)
        context = self

        while source.token?
          part = context.parse_tag( source, @offset, source.get)
          context = context.add( part)
        end

        if context != self
          source.error( @offset, 'Tags inside liquid tag not closed')
        end

        nil
      end
    end
  end
end