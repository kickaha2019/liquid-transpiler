# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagComment < Part
      def initialize(source, offset, parent)
        super
        source.skip_space
        source.next('-')

        unless source.next('%}')
          source.error(source.offset, 'Expected %}')
        end

        unless source.find(/{%(-|)\s*endcomment[^a-zA-Z0-9_]/)
          source.error(source.offset, 'endcomment tag not found')
        end

        source.next('{%')
        source.next('-')
        unless :endcomment == source.expect_name
          source.error(source.offset, 'Internal error')
        end

        TagEndcomment.new(source, source.offset, self)
      end
    end
  end
end
