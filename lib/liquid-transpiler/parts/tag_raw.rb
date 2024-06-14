module LiquidTranspiler
  module Parts
    class TagRaw < Part
      def setup( source)
        source.skip_space
        source.next( '-')

        unless source.next( '%}')
          source.error( source.offset,'Expected %}')
        end

        text = source.find( /{%(-|)\s*endraw[^a-zA-Z0-9_]/)
        unless text
          source.error( source.offset,'endraw tag not found')
        end
        add( Text.new( source, @offset, text))

        source.next( '{%')
        source.next( '-')
        unless :endraw == source.expect_name
          source.error( source.offset, 'Internal error')
        end

        part = TagEndraw.new( source, source.offset, self)
        part.setup( source)
      end
    end
  end
end