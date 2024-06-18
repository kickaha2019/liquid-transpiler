# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagRaw < Part
      def initialize(source, offset, parent)
        super
        source.skip_space
        source.next('-')

        unless source.next('%}')
          source.error(source.offset, 'Expected %}')
        end

        text = source.find(/{%(-|)\s*endraw[^a-zA-Z0-9_]/)
        unless text
          source.error(source.offset, 'endraw tag not found')
        end
        add(Text.new(source, @offset, text))

        source.next('{%')
        source.next('-')
        unless source.expect_name == :endraw
          source.error(source.offset, 'Internal error')
        end

        TagEndraw.new(source, source.offset, self)
      end
    end
  end
end
