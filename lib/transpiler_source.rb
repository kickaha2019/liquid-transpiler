module LiquidTranspiler
  class TranspilerSource
    attr_reader :offset

    def initialize( path)
      @path   = path
      @offset = 0
      @text   = IO.read( path)
    end

    def eof?
      @offset >= @text.size
    end

    def expect_name
      skip_space
      if token = get
        if /^[a-z_]/i =~ token
          token
        else
          raise TranspilerError.new( @offset, 'Expected name')
        end
      else
        raise TranspilerError.new( @offset, 'Expected name')
      end
    end

    def find( re)
      prefix = nil
      @text.match( re, @offset) do |m|
        was, @offset = @offset, m.begin(0)
        prefix = @text[was...@offset]
      end
      prefix
    end

    def get
      skip_space
      return nil if eof?

      letter = @text[@offset..@offset]
      if [',',']','[',':','|'].include?( letter)
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
        if /[0-9]/ =~ @text[@offset+1..@offset+1]
          get_number
        else
          @offset += 1
          return letter
        end
      when '-'
        if /[\.0-9]/ =~ @text[@offset+1..@offset+1]
          get_number
        else
          @offset += 1
          return letter
        end
      else
        nil
      end
    end

    def get_double_quoted_string
      i = @offset + 1

      while m = @text.match( /[\\"]/, i)
        i = m.begin(0)
        if @text[i..i] == '\\'
          i += 2
        else
          string = @text[@offset..i]
          @offset = i + 1
          return string
        end
      end

      raise TranspilerError.new( @offset, 'Unclosed quoted string')
    end

    def get_name
      origin = @offset
      if m = @text.match( /[^a-z0-9_]/, @offset)
        @offset = m.end(0) - 1
      else
        @offset = @text.size
      end
      @text[origin...@offset]
    end

    def get_number
      origin = @offset
      if m = @text.match( /[^0-9\.]/, @offset+1)
        @offset = m.end(0) - 1
      else
        @offset = @text.size
      end
      @text[origin...@offset]
    end

    def get_single_quoted_string
      raise 'Dev'
    end

    def line_number( offset)
      lines = 1
      index = 0

      while (index < offset)
        if (index1 = @text.index( "\n", index)) && (index1 < offset)
          index = index1 + 1
          lines += 1
        else
          break
        end
      end

      lines
    end

    def next( expected)
      if @text[@offset...(@offset+expected.size)] == expected
        @offset += expected.size
        true
      else
        false
      end
    end

    def peek( n)
      @text[@offset..(@offset+n-1)]
    end

    def remnant
      @offset, text = @text.size, @text[@offset..-1]
      text
    end

    def skip_space
      until eof?
        @text.match( /\S/, @offset) do |m|
          @offset = m.begin(0)
        end

        if (! eof?) && (@text[@offset..@offset] == '#')
          if i = @text.index( "\n", @offset+1)
            @offset = i + 1
          else
            @offset = @text.size
            break
          end
        else
          break
        end
      end
    end
  end
end