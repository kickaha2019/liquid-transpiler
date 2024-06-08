module LiquidTranspiler
  module Parts
    class TagCycle < Part
      def initialize( offset, parent)
        super( offset, parent)
        @key   = nil
        @cycle = []
      end

      def add( part)
        raise TranspilerError.new( part.offset, 'Internal error')
      end

      def find_arguments( names)
        names.cycle( @key)
      end

      def generate( context, indent, io)
        variable = context.cycle( @key)
        io.print ' ' * indent
        io.puts "#{variable} += 1"
        io.print ' ' * indent
        io.puts "#{variable} = 0 if #{variable} >= #{@cycle.size}"

        io.print(' ' * indent)
        io.print context.output
        io.puts " << [#{@cycle.join(',')}][#{variable}]"
      end

      def setup( source)
        @cycle << source.expect_literal

        while token = source.get
          case token
          when ':'
            @key = @cycle.delete_at(0)
          when ','
          else
            break
          end

          @cycle << source.expect_literal
        end

        if @key.nil?
          @key = '[' + @cycle.join(',') + ']'
        end

        token
      end
    end
  end
end