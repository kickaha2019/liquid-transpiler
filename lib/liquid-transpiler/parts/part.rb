# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class Part
      # SUB = [['\\', '\\\\'],
      #        ["\n", '\\n'],
      #        ['"',  '\\"'],
      #        ['#',  '\\#']]

      attr_reader :offset, :parent

      def initialize(source, offset, parent)
        @source        = source
        @line, @column = source.position(offset)
        @offset        = offset
        @parent        = parent
        @children      = []
      end

      # rubocop:disable Metrics/MethodLength
      def add(part)
        @children << part

        case part.class_name
        when 'Embedded'
          self
        when 'EndOfFile'
          error(part.offset, 'Unexpected EOF')
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
        when 'TagTablerow'
          part
        when 'TagUnless'
          part
        when 'Text'
          self
        else
          error(part.offset, "Unexpected #{part.name}")
        end
      end
      # rubocop:enable Metrics/MethodLength

      def add_text(offset, text, rstrip, lstrip)
        text = text.lstrip if rstrip
        text = text.rstrip if lstrip
        if text.size.positive?
          add(Text.new(@source, offset, text))
        end
      end

      def class_name
        self.class.name.split('::')[-1]
      end

      def digest(source, rstrip)
        text = source.find(digest_find)
        if text
          lstrip, part, rstrip1 = parse(source)
          add_text(source.offset, text, rstrip, lstrip)
          [part, rstrip1]
        else
          add_text(source.offset, source.remnant, rstrip, false)
          [Parts::EndOfFile.new(source, source.offset, nil), false]
        end
      end

      def digest_find
        /({{|{%)/
      end

      def error(offset, msg)
        @source.error(offset, msg)
      end

      def find_arguments(names)
        @children.each do |child|
          child.find_arguments(names)
        end
      end

      def generate(context, indent)
        @children.each do |child|
          child.record(context)
          child.generate(context, indent)
        end
      end

      def html_encode(text)
        text.gsub(/[\\\n"#]/) do |block|
          block == "\n" ? '\\n' : "\\#{block}"
        end
      end

      def name
        clazz = class_name
        m = /^Tag(.*)$/.match(clazz)
        if m
          "tag #{m[1].downcase}"
        else
          clazz
        end
      end

      def parse(source)
        source.skip_space
        offset = source.offset

        if source.next('{{')
          lstrip = source.next('-')
          expr, term = Expression.parse(source)

          source.skip_space
          rstrip = source.next('-')
          if term.nil? && source.next('}}')
            [lstrip, Parts::Embedded.new(source, offset, expr), rstrip]
          else
            error(offset, 'Expecting }}')
          end
        elsif source.next('{%')
          lstrip = source.next('-')
          token  = source.get

          if token
            part = parse_tag(source, offset, token)
            if source.token?
              source.error(offset, "Unexpected #{source.get}")
            end
            source.skip_space
          else
            part = nil
          end

          rstrip = source.next('-')
          if source.next('%}')
            [lstrip, part, rstrip]
          else
            source.error(offset, 'Expecting %}')
          end
        else
          source.error(offset, 'Internal error')
        end
      end

      def parse_tag(source, offset, token)
        clazz = Object.const_get("LiquidTranspiler::Parts::Tag#{token.to_s.capitalize}")
        if clazz
          clazz.new(source, offset, self)
        else
          source.error(offset, "Bad tag name: #{token}")
        end
      end

      def record(context)
        context.record(class_name, @line, @column)
      end
    end
  end
end
