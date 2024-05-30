module LiquidTranspiler
  module Parts
    class Part
      attr_reader :offset

      def initialize( offset)
        @offset   = offset
        @children = []
      end

      def add_text( offset, text, rstrip, lstrip)
        text = text.lstrip if rstrip
        text = text.rstrip if lstrip
        if text.size > 0
          @children << Text.new( offset, text)
        end
      end

      def digest( source, rstrip)
        if text = source.find( digest_find)
          lstrip, part, rstrip1 = parse( source)
          add_text( source.offset, text, rstrip, lstrip)
          return part, rstrip1
        else
          add_text( source.offset, source.remnant, rstrip, false)
          return Parts::EndOfFile.new( source.offset), false
        end
      end

      def digest_find
        /({{|{%)/
      end

      def find_arguments( names)
        @children.each do |child|
          child.find_arguments( names)
        end
      end

      def generate( context, indent, io)
        @children.each do |child|
          child.generate( context, indent, io)
        end
      end

      def parse( source)
        source.skip_space
        offset = source.offset
        if source.next( '{{')
          lstrip = source.next( '-')
          expr, term = TranspilerExpression.parse( source)

          source.skip_space
          rstrip = source.next( '-')
          if term.nil? && source.next( '}}')
            return lstrip, Parts::Embedded.new( offset, expr), rstrip
          else
            raise TranspilerError.new( offset, 'Expecting }}')
          end
        elsif source.next( '{%')
          lstrip = source.next( '-')
          name   = source.expect_name
          part   = Object.const_get( 'LiquidTranspiler::Parts::Tag' + name.capitalize).new( offset)
          term   = part.setup( source)

          unless term.nil?
            raise TranspilerError.new( offset, 'Unexpected ' + term.to_s)
          end

          source.skip_space
          rstrip = source.next( '-')
          if source.next( '%}')
            return lstrip, part, rstrip
          else
            raise TranspilerError.new( offset, 'Expecting %}')
          end
        else
          raise TranspilerError.new( offset, 'Internal error')
        end
      end
    end
  end
end
