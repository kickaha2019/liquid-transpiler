# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagCycle < Part
      # rubocop:disable Lint/EmptyWhen
      def initialize(source, offset, parent)
        super
        @key   = nil
        @cycle = []
        @cycle << source.get

        token = source.get
        until token.nil?
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
          @key = '[' + @cycle.collect(&:to_s).join(',') + ']'
        end

        source.unget token
      end
      # rubocop:enable Lint/EmptyWhen

      def add(part)
        error(part.offset, 'Internal error')
      end

      def find_arguments(names)
        names.cycle(@key)
        @cycle.each do |cycle|
          names.reference(cycle) if cycle.is_a?(Symbol)
        end
      end

      def generate(context, indent)
        variable = context.cycle(@key)
        context.print ' ' * indent
        context.puts "#{variable} += 1"
        context.print ' ' * indent
        context.puts "#{variable} = 0 if #{variable} >= #{@cycle.size}"

        context.print(' ' * indent)
        context.print context.output
        values = @cycle.collect do |cycle|
          if cycle.is_a?(Symbol)
            context.variable(cycle)
          elsif cycle.is_a?(String)
            context.string(cycle)
          else
            cycle.to_s
          end
        end
        context.puts " << [#{values.join(',')}][#{variable}]"
      end
    end
  end
end
