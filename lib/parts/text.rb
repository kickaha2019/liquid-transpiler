require_relative 'part'

module LiquidTranspiler
  module Parts
    class Text < Part
      SUB = [['\\', '\\\\'],
             ["\n", '\\n'],
             ['"',  '\\"'],
             ['#',  '\\#']]

      def initialize( offset, text)
        super( offset, nil)
        @text = text
      end

      def add( part)
        raise TranspilerError.new( part.offset, 'Internal error')
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
          subbed = @text

          SUB.each do |sub|
            subbed = subbed.gsub( * sub)
          end

          io.puts ' << "' + subbed + '"'
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
