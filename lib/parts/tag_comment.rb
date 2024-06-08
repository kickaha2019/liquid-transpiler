module LiquidTranspiler
  module Parts
    class TagComment < Part
      def initialize( offset, parent)
        super( offset, parent)
      end
      #
      # def add( part)
      #   @parent.add( part)
      # end

      def setup( source)
        source.skip_space
        source.next( '-')

        unless source.next( '%}')
          raise TranspilerError.new( source.offset,'Expected %}')
        end

        unless source.find( /{%(-|)\s*endcomment[^a-zA-Z0-9_]/)
          raise TranspilerError.new( source.offset,'endcomment tag not found')
        end

        source.next( '{%')
        source.next( '-')
        unless 'endcomment' == source.expect_name
          raise TranspilerError.new( source.offset, 'Internal error')
        end

        part = TagEndcomment.new( source.offset, self)
        part.setup( source)
      end
    end
  end
end