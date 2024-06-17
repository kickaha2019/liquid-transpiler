# frozen_string_literal: true
module LiquidTranspiler
  module Parts
    class TagCycle < Part
      def initialize(source, offset, parent)
        super
        @key   = nil
        @cycle = []
        @cycle << source.get

        token = source.get
        while token
          case token
          when ':'
            @key = @cycle.delete_at(0).to_s
          when ','
          else
            break
          end

          @cycle << source.get
          token = source.get
        end

        if @key.nil?
          @key = '[' + @cycle.collect { |c| c.to_s }.join(',') + ']'
        end

        source.unget token
      end

      def add(part)
        error(part.offset, 'Internal error')
      end

      def find_arguments(names)
        names.cycle(@key)
        @cycle.each do |cycle|
          names.reference(cycle) if cycle.is_a?(Symbol)
        end
      end

      def generate(context, indent, io)
        variable = context.cycle(@key)
        io.print ' ' * indent
        io.puts "#{variable} += 1"
        io.print ' ' * indent
        io.puts "#{variable} = 0 if #{variable} >= #{@cycle.size}"

        io.print(' ' * indent)
        io.print context.output
        values = @cycle.collect do |cycle|
          if cycle.is_a?(Symbol)
            context.variable(cycle)
          else
            cycle
          end
        end
        io.puts " << [#{values.join(',')}][#{variable}]"
      end
    end
  end
end
