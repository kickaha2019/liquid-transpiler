# frozen_string_literal: true

require_relative 'source'

# rubocop:disable Style/EmptyElse
# rubocop:disable Style/RedundantRegexpEscape

module LiquidTranspiler
  class Source
    include ParserExpressions

    attr_reader :offset

    RESERVED_WORDS = [:true, :false, :empty].freeze

    def initialize(transpiler, path, text)
      @transpiler  = transpiler
      @path        = path
      @offset      = 0
      @text        = text
      @ungot       = []
      @ignore_eol  = true
      @line        = 1
      @posn_index  = 0
      @posn_line   = 1
      @posn_column = 1
    end

    def eof?
      @offset >= @text.size
    end

    def error(offset, msg)
      line, column = position(offset)
      details = <<~ERROR
        File:   #{@path.split('/')[-1]}
        Line:   #{line}
        Column: #{column}
        Text:   #{peek_from(offset, 50).gsub("\n", ' ')}
        Error:  #{msg}
      ERROR
      raise TranspilerError, details
    end

    def expect_literal
      token = get
      if token.is_a?(String)
        token
      else
        error(@offset, 'Expected literal')
      end
    end

    def expect_name
      token = get
      if token.nil?
        error(@offset, 'Expected name')
      else
        unless token.is_a?(Symbol) && !RESERVED_WORDS.include?(token)
          error(@offset, 'Expected name')
        end
        token
      end
    end

    def expect_nested_source
      text = expect_literal
      Source.new(@transpiler, @path, text)
    end

    def filter_class(name)
      @transpiler.filter_class(name)
    end

    def find(regex)
      prefix = nil
      @text.match(regex, @offset) do |m|
        was, @offset = @offset, m.begin(0)
        prefix = @text[was...@offset]
        @line += prefix.count("\n")
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

      if [',', ']', '[', ':', '|', '(', ')', "\n"].include?(letter)
        @offset += 1
        return letter
      elsif /[0-9]/ =~ letter
        return get_number
      elsif /[a-z_]/i =~ letter
        return get_name
      end

      case letter
      when '"'
        get_quoted_string '"'
      when "'"
        get_quoted_string "'"
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
      else
        nil
      end
    end
    # rubocop:enable Metrics/MethodLength

    def ignore_eol(flag)
      @ignore_eol = flag
    end

    def line_number
      @line
    end

    def next_string?(expected)
      unless @ungot.empty?
        if @ungot[-1] == expected
          @line += 1 if expected == "\n"
          @ungot.pop
          return true
        else
          return false
        end
      end

      if @text[@offset...(@offset + expected.size)] == expected
        @line += 1 if expected == "\n"
        @offset += expected.size
        true
      else
        false
      end
    end

    def next_token?(expected)
      term = get
      if term == expected
        true
      else
        unget term
        false
      end
    end

    def peek(distance)
      @text[@offset..(@offset + distance - 1)]
    end

    def peek_from(offset, distance)
      @text[offset..(offset + distance - 1)]
    end

    def position(offset)
      if @posn_index > offset
        @posn_index  = 0
        @posn_line   = 1
        @posn_column = 1
      end

      while @posn_index < offset
        @posn_index += 1
        if @text[@posn_index] == "\n"
          @posn_line   += 1
          @posn_column =  1
        else
          @posn_column += 1
        end
      end

      [@posn_line, @posn_column]
    end

    def remnant
      @offset, text = @text.size, @text[@offset..]
      @line += text.count("\n")
      text
    end

    def skip_space
      until eof?
        @text.match(/[^ \t]/, @offset) do |m|
          @offset = m.begin(0)
        end

        case @text[@offset..@offset]
        when "\n"
          if @ignore_eol
            @line   += 1
            @offset += 1
          else
            return
          end
        when '#'
          if m1 = /(\n|-%}|%}|}})/.match(@text, @offset + 1)
            @offset = m1.begin(0)
            if @ignore_eol
              next_string?("\n")
            else
              return
            end
          else
            @offset = @text.size
            return
          end
        else
          return
        end
      end
    end

    def token?
      term = get
      if term.nil?
        false
      else
        unget(term)
        true
      end
    end

    def unget(token)
      @ungot << token if token
    end

    private

    def get_quoted_string(delimiter)
      i = @text.index(delimiter, @offset + 1)
      if i
        s       = @text[(@offset+1)..(i-1)]
        @offset = i + 1
        s
      else
        error(@offset, 'Unclosed quoted string')
      end
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
      if m = @text.match(/[^0-9\-a-z_.]/i, @offset)
        finish = m.end(0) - 1
      else
        finish = @text.size
      end

      if i = @text[origin...finish].index('..')
        @offset = i + origin
      else
        @offset = finish
      end

      number = @text[origin...@offset]
      return get_name if /[a-z_]|^-.*-/i =~ number

      /[.]/ =~ number ? number.to_f : number.to_i
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
  end
end

# rubocop:enable Style/EmptyElse
# rubocop:enable Style/RedundantRegexpEscape
