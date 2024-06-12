module LiquidTranspiler
  module Parts
    class TagRaw < Part
      def initialize( offset, parent)
        super( offset, parent)
      end

      def setup( source)
        source.skip_space
        source.next( '-')

        unless source.next( '%}')
          raise TranspilerError.new( source.offset,'Expected %}')
        end

        text = source.find( /{%(-|)\s*endraw[^a-zA-Z0-9_]/)
        unless text
          raise TranspilerError.new( source.offset,'endraw tag not found')
        end
        add( Text.new( @offset, text))

        source.next( '{%')
        source.next( '-')
        unless :endraw == source.expect_name
          raise TranspilerError.new( source.offset, 'Internal error')
        end

        part = TagEndraw.new( source.offset, self)
        part.setup( source)
      end
    end
  end
end