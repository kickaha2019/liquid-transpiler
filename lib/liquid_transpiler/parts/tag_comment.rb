# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagComment < Part
      def initialize(source, offset, parent)
        super
        source.skip_space
        source.next_string?('-')

        unless source.next_string?('%}')
          source.error(source.offset, 'Expected %}')
        end

        unless source.find(/{%(-|)\s*endcomment[^a-zA-Z0-9_]/)
          source.error(source.offset, 'endcomment tag not found')
        end

        source.next_string?('{%')
        source.next_string?('-')
        unless source.expect_name == :endcomment
          source.error(source.offset, 'Internal error')
        end

        TagEndcomment.new(source, source.offset, self)
      end
    end
  end
end
