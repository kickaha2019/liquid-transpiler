require_relative '../expression'

module LiquidTranspiler
  module Parts
    class Part
      attr_reader :offset

      def initialize( offset)
        @offset   = offset
        @children = []
      end

      def add_text( text, rstrip, lstrip)
        text = text.lstrip if rstrip
        text = text.rstrip if lstrip
        if text.size > 0
          @children << Text.new( text)
        end
      end

      def deduce_arguments
        @children.collect do |child|
          child.deduce_arguments
        end.flatten
      end

      def digest( source, rstrip)
        if text = source.find( digest_find)
          lstrip, part, rstrip1 = parse( source)
          add_text( text, rstrip, lstrip)
          return part, rstrip1
        else
          add_text( source.remnant, rstrip, false)
          return Parts::EndOfFile.new( source.offset), false
        end
      end

      def digest_find
        /({{|{%)/
      end

      def generate( arguments, indent, io)
        @children.each do |child|
          child.generate( arguments, indent, io)
        end
      end

      def parse( source)
        source.skip_space
        offset = source.offset
        if source.next( '{{')
          lstrip = source.next( '-')
          expr, term = Expression.parse( source)

          source.skip_space
          rstrip = source.next( '-')
          if term.nil? && source.next( '}}')
            return lstrip, Parts::Embedded.new( offset, expr), rstrip
          else
            raise TranspilerError.new( offset, 'Expecting }}')
          end
        else
          lstrip = source.next( '-')
          name   = source.expect_name
          part   = Object.const_get( 'Tag' + name.capitalize).new( offset, source)

          source.skip_space
          rstrip = source.next( '-')
          if source.next( '%}')
            return lstrip, part, rstrip
          else
            raise TranspilerError.new( offset, 'Expecting %}')
          end
        end
      end
    end
  end
end
