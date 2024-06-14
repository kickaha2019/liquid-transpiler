require_relative 'part'

module LiquidTranspiler
  module Parts
    class Text < Part
      def initialize( source, offset, text)
        super( source, offset, nil)
        @text = text
      end

      def add( part)
        error( part.offset, 'Internal error')
      end

      def empty?
        @text.empty?
      end

      def find_arguments( names)
      end

      def generate( context, indent, io)
        unless empty?
          io.print(' ' * indent)
          io.print context.output
          io.puts ' << "' + html_encode( @text) + '"'
        end
      end

      def name
        'text section'
      end

      def strip
        @text = @text.strip
      end

      def to_s
        @text
      end
    end
  end
end
