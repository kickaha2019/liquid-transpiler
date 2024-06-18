# frozen_string_literal: true

# rubocop:disable Style/RedundantRegexpEscape

module LiquidTranspiler
  class Source
    attr_reader :offset

    RESERVED_WORDS = [:true, :false, :empty]

    def initialize(path)
      @path   = path
      @offset = 0
      @text   = IO.read(path)
      @ungot  = []
    end

    def eof?
      @offset >= @text.size
    end

    def error(offset, msg)
      line, column, peek = position(offset)
      details = <<~ERROR
        File:   #{@path.split('/')[-1]}
        Line:   #{line}
        Column: #{column}
        Text:   #{peek}
        Error:  #{msg}
      ERROR
      raise TranspilerError.new(details)
    end

    def expect_literal
      if token = get
        if token.is_a?(Symbol)
          error(@offset, 'Expected literal')
        elsif /^['"]/ =~ token
          token
        else
          error(@offset, 'Expected literal')
        end
      else
        error(@offset, 'Expected literal')
      end
    end

    def expect_name
      if token = get
        unless token.is_a?(Symbol) && !RESERVED_WORDS.include?(token)
          error(@offset, 'Expected name')
        end
        token
      else
        error(@offset, 'Expected name')
      end
    end

    def find(regex)
      prefix = nil
      @text.match(regex, @offset) do |m|
        was, @offset = @offset, m.begin(0)
        prefix = @text[was...@offset]
      end
      prefix
    end

    # rubocop:disable Metrics/MethodLength
    def get
      unless @ungot.empty?
        return @ungot.pop
      end

      skip_space
      return nil if eof?

      letter = @text[@offset..@offset]

      if [',', ']', '[', ':', '|', '(', ')'].include?(letter)
        @offset += 1
        return letter
      elsif /[0-9]/ =~ letter
        return get_number
      elsif /[a-z_]/i =~ letter
        return get_name
      end

      case letter
      when '"'
        get_double_quoted_string
      when "'"
        get_single_quoted_string
      when '.'
        if /[0-9]/ =~ @text[@offset + 1..@offset + 1]
          get_number
        else
          start = @offset
          @offset += 1
          while (@offset < @text.size) && @text[@offset..@offset] == '.'
            @offset += 1
          end
          @text[start...@offset]
        end
      when '-'
        return nil if ['%', '}'].include?(@text[@offset + 1..@offset + 1])

        get_number
      when '='
        get_operator
      when '<'
        get_operator
      when '>'
        get_operator
      when '!'
        get_operator
      end
    end
    # rubocop:enable Metrics/MethodLength

    def get_double_quoted_string
      i = @offset + 1

      while m = @text.match(/[\\"]/, i)
        i = m.begin(0)
        if @text[i..i] == '\\'
          i += 2
        else
          string = @text[@offset..i]
          @offset = i + 1
          return string
        end
      end

      error(@offset, 'Unclosed quoted string')
    end

    def get_name
      origin = @offset
      if m = @text.match(/[^a-z0-9_\-]/, @offset)
        @offset = m.end(0) - 1
      else
        @offset = @text.size
      end

      name = @text[origin...@offset]
      if /^(-|)\d+$/ =~ name
        error(origin, 'Syntax error')
      end
      name.to_sym
    end

    def get_number
      origin = @offset
      if m = @text.match(/[^0-9\-a-z_\.]/i, @offset)
        finish = m.end(0) - 1

        if i = @text[origin...finish].index('..')
          @offset = i + origin
        else
          @offset = finish
        end

        number = @text[origin...@offset]
        return get_name if /[a-z_]|^-.*-/i =~ number
      else
        @offset = origin + 1
      end
      @text[origin...@offset]
    end

    def get_operator
      origin = @offset
      if m = @text.match(/[^=<>]/, @offset + 1)
        @offset = m.end(0) - 1
      else
        @offset = @text.size
      end
      @text[origin...@offset]
    end

    def get_single_quoted_string
      i = @offset + 1

      while m = @text.match(/[\\']/, i)
        i = m.begin(0)
        if @text[i..i] == '\\'
          i += 2
        else
          string = @text[@offset..i]
          @offset = i + 1
          return string
        end
      end

      error(@offset, 'Unclosed quoted string')
    end

    def next(expected)
      unless @ungot.empty?
        if @ungot[-1] == expected
          @ungot.pop
          return true
        else
          return false
        end
      end

      if @text[@offset...(@offset + expected.size)] == expected
        @offset += expected.size
        true
      else
        false
      end
    end

    def peek(distance)
      @text[@offset..(@offset + distance - 1)]
    end

    def position(offset)
      lines = 1
      index = 0

      while index < offset
        if (index1 = @text.index("\n", index)) && (index1 < offset)
          index = index1 + 1
          lines += 1
        else
          break
        end
      end

      [lines, (offset - index + 1), @text[offset...(offset + 50)].gsub("\n", ' ')]
    end

    def remnant
      @offset, text = @text.size, @text[@offset..]
      text
    end

    def skip_space
      until eof?
        @text.match(/\S/, @offset) do |m|
          @offset = m.begin(0)
        end

        if !eof? && (@text[@offset..@offset] == '#')
          if m = /(\n|-%\}|%\}|\}\})/.match(@text, @offset + 1)
            @offset = m.begin(0)
            next("\n")
          else
            @offset = @text.size
            break
          end
        else
          break
        end
      end
    end

    def token?
      if term = get
        unget(term)
        true
      else
        false
      end
    end

    def unget(token)
      @ungot << token if token
    end
  end
end

# rubocop:enable Style/RedundantRegexpEscape
