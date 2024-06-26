# frozen_string_literal: true

require_relative 'part'

module LiquidTranspiler
  module Parts
    class Template < Part
      class Names
        # rubocop:disable Metrics/ParameterLists
        def initialize(arguments = {}, cycles = {}, increments = {}, variables = {})
          @arguments  = arguments
          @cycles     = cycles
          @increments = increments
          @variables  = variables
          @locals     = {}
        end
        # rubocop:enable Metrics/ParameterLists

        def arguments
          @arguments.keys
        end

        def assign(name)
          unless known?(name)
            @variables[name] = true
            @locals[name]    = true
          end
        end

        def cycle(name)
          @cycles[name] = true
        end

        def cycles
          @cycles.keys
        end

        def increment(name)
          @increments[name] = true
        end

        def increments
          @increments.keys
        end

        def known?(name)
          @arguments[name] || @variables[name]
        end

        def local?(name)
          @locals[name]
        end

        def locals(&block)
          @locals.each_key(&block)
        end

        def reference(name)
          @arguments[name] = true unless known?(name)
        end

        def spawn
          Names.new(@arguments,
                    @cycles,
                    @increments,
                    Hash.new { |h, k| h[k] = @variables[k] })
        end
      end

      def add(part)
        if part.is_a?(EndOfFile)
          return self
        end

        super(part)
      end

      def deduce_names(globals)
        Names.new.tap do |names|
          globals.each { |global| names.assign(global.to_sym) }
          find_arguments(names)
        end
      end
    end
  end
end
