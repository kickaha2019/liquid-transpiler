# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagLiquid < Part
      def initialize(source, offset, parent)
        super
        context = self
        source.ignore_eol(false)
        newline = true

        while source.token?
          if source.next_token?("\n")
            newline = true
          else
            unless newline
              source.error(@offset, "Unexpected #{source.get}")
            end
            part    = context.parse_tag(source, @offset, source.get)
            context = context.add(part)
            newline = false
          end
        end

        source.ignore_eol(true)
        if context != self
          source.error(@offset, 'Tags inside liquid tag not closed')
        end
      end
    end
  end
end
