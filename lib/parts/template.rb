require_relative 'part'

module LiquidTranspiler
  module Parts
    class Template < Part
      def initialize
        super( 0)
      end

      def add( part)
        @children << part
        clazz = part.class.name.split('::')[-1]

        case clazz
        when 'Embedded'
          return self
        when 'EndOfFile'
          return self
        else
          raise TranspilerError.new( part.offset, 'Unexpected tag')
        end
      end

      def deduce_arguments
        super.uniq
      end
    end
  end
end
