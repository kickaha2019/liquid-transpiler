# frozen_string_literal: true

module LiquidTranspiler
  module Parts
    class TagRender < Part
      def initialize(source, offset, parent)
        super
        @target     = nil
        @parameters = {}
        @for        = false

        # rubocop:disable Style/RedundantRegexpEscape
        if m = /^['"]([a-z0-9_\-]+)['"]$/i.match(source.get)
          @target = m[1]
        else
          source.error(@offset, 'Expected render target')
        end
        # rubocop:enable Style/RedundantRegexpEscape

        term = source.get
        source.unget case term
                     when ','
                       setup_parameters(source, term)
                     when :with
                       setup_parameters(source, term)
                     when :for
                       @for = true
                       setup_with(source)
                     else
                       term
                     end
      end

      def add(_part)
        error(@offset, 'Internal error')
      end

      def find_arguments(names)
        @parameters.each_value do |expr|
          expr.find_arguments(names)
        end
      end

      def generate(context, indent, io)
        info = context.signature(@target)
        if info
          call_arguments = {}
          @parameters.each_pair do |key, value|
            call_arguments[key] = value.generate(context)
          end

          if @for
            argument = call_arguments.keys.first
            for_name, = context.for(argument)
            io.puts "#{for_name}l = f(#{call_arguments[argument]},nil)"
            call_arguments[:forloop] = "#{for_name}l"
            call_arguments[argument] = for_name

            io.print ' ' * indent
            io.puts "#{for_name}l.each do |#{for_name}|"
            generate_call(info, call_arguments, context, indent + 2, io)
            io.print ' ' * indent
            io.puts 'end'

            context.endfor(argument)
          else
            generate_call(info, call_arguments, context, indent, io)
          end
        else
          error(@offset, "Undefined render target: #{@target}")
        end
      end

      def generate_call(info, parameters, context, indent, io)
        io.print ' ' * indent
        io.print context.output
        io.print "<< t#{info[0]}"

        separ = '('
        info[1].arguments.each do |arg|
          io.print separ
          separ = ','
          io.print parameters[arg] || 'nil'
        end

        io.print ')' if separ != '('
        io.puts
      end

      def setup_more?(term)
        (term == ',') || (term == :with)
      end

      def setup_parameters(source, term)
        while setup_more?(term)
          term = source.get
          if term == :with
            term   = source.get
          end

          term1 = source.get
          source.unget(term1)
          source.unget(term)

          if term1 == ':'
            name = source.expect_name
            source.get
            @parameters[name], term = Expression.parse(source)
          else
            expr, term = Expression.parse(source)
            if term == :as
              name = source.expect_name
              @parameters[name] = expr
              term = source.get
            else
              @parameters[@target.to_sym] = expr
            end
          end
        end

        term
      end

      def setup_with(source)
        expr, term = Expression.parse(source)
        if term == :as
          name = source.expect_name
          term = source.get
        else
          name = @target.to_sym
        end

        @parameters[name] = expr
        term
      end
    end
  end
end
