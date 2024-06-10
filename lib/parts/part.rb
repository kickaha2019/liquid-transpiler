module LiquidTranspiler
  module Parts
    class Part
      # SUB = [['\\', '\\\\'],
      #        ["\n", '\\n'],
      #        ['"',  '\\"'],
      #        ['#',  '\\#']]

      attr_reader :offset, :parent

      def initialize( offset, parent)
        @offset   = offset
        @parent   = parent
        @children = []
      end

      def add( part)
        @children << part

        case part.class_name
        when 'Embedded'
          self
        when 'EndOfFile'
          raise TranspilerError.new( part.offset, 'Unexpected EOF')
        when 'TagAssign'
          self
        when 'TagCapture'
          part
        when 'TagCase'
          part
        when 'TagComment'
          self
        when 'TagCycle'
          self
        when 'TagDecrement'
          self
        when 'TagEcho'
          self
        when 'TagFor'
          part
        when 'TagIf'
          part
        when 'TagIncrement'
          self
        when 'TagLiquid'
          self
        when 'TagRaw'
          self
        when 'TagRender'
          self
        when 'Text'
          self
        else
          raise TranspilerError.new( part.offset,
                                     'Unexpected ' + part.name)
        end
      end

      def add_text( offset, text, rstrip, lstrip)
        text = text.lstrip if rstrip
        text = text.rstrip if lstrip
        if text.size > 0
          add( Text.new( offset, text))
        end
      end

      def class_name
        self.class.name.split('::')[-1]
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

      def html_encode( text)
        return text.gsub( /[\\\n"#]/) do |block|
          (block == "\n") ? '\\n' : '\\' + block
        end
        #
        # encoded = []
        # offset  = 0
        # while offset < text.size
        #   m = text.match( /([\\\n"#])/, offset)
        #   if m
        #     encoded << text[offset...m.begin(0)]
        #     encoded << '\\'
        #     encoded << m[1]
        #     offset  = m.end(0)
        #   else
        #     encoded << text[offset..-1]
        #     offset = text.size
        #   end
        # end

        #encoded.join('')
        # p ['DEBUG200', text]
        # p ['DEBUG201', encoded.join('')]
        #
        # SUB.inject( text) {|r,e| r.gsub( * e)}
      end

      def name
        clazz = class_name
        if m = /^Tag(.*)$/.match( clazz)
          'tag ' + m[1].downcase
        else
          clazz
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
          token  = source.get

          if token
            part, term = parse_tag( source, token)
            unless term.nil?
              raise TranspilerError.new( offset, 'Unexpected ' + term.to_s)
            end
            source.skip_space
          else
            part = nil
          end

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

      def parse_tag( source, token)
        begin
          clazz = Object.const_get( 'LiquidTranspiler::Parts::Tag' + token.capitalize)
          part  = clazz.new( offset, self)
        rescue
          raise TranspilerError.new( offset, "Bad tag name: #{token}")
        end

        term = part.setup( source)
        return part, term
      end
    end
  end
end
