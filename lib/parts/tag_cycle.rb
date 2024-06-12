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
        @cycle.each do |cycle|
          names.reference( cycle) if cycle.is_a?( Symbol)
        end
      end

      def generate( context, indent, io)
        variable = context.cycle( @key)
        io.print ' ' * indent
        io.puts "#{variable} += 1"
        io.print ' ' * indent
        io.puts "#{variable} = 0 if #{variable} >= #{@cycle.size}"

        io.print(' ' * indent)
        io.print context.output
        values = @cycle.collect do |cycle|
          if cycle.is_a?( Symbol)
            context.variable(cycle)
          else
            cycle
          end
        end
        io.puts " << [#{values.join(',')}][#{variable}]"
      end

      def setup( source)
        @cycle << source.get

        while token = source.get
          case token
          when ':'
            @key = @cycle.delete_at(0).to_s
          when ','
          else
            break
          end

          @cycle << source.get
        end

        if @key.nil?
          @key = '[' + @cycle.collect {|c| c.to_s}.join(',') + ']'
        end

        token
      end
    end
  end
end