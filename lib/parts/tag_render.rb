module LiquidTranspiler
  module Parts
    class TagRender < Part
      def initialize( offset, parent)
        super( offset, parent)
        @target     = nil
        @parameters = {}
        @for        = false
      end

      def add( part)
        raise TranspilerError.new( @offset, 'Internal error')
      end

      def find_arguments( names)
        @parameters.each_value do |expr|
          expr.find_arguments( names)
        end
      end

      def generate( context, indent, io)
        if info = context.signature( @target)
          call_arguments = {}
          @parameters.each_pair do |key, value|
            call_arguments[key] = value.generate( context)
          end

          if @for
            argument = call_arguments.keys.first
            for_name, _ = context.for( argument)
            io.puts "#{for_name}l = f(#{call_arguments[argument]},nil)"
            call_arguments['forloop'] = for_name + 'l'
            call_arguments[argument]  = for_name

            io.print ' ' * indent
            io.puts "#{for_name}l.each do |#{for_name}|"
            generate_call( info, call_arguments, context, indent+2, io)
            io.print ' ' * indent
            io.puts 'end'

            context.endfor( argument)
          else
            generate_call( info, call_arguments, context, indent, io)
          end
        else
          raise TranspilerError.new( @offset,
                                     "Undefined render target: #{@target}")
        end
      end

      def generate_call( info, parameters, context, indent, io)
        io.print ' ' * indent
        io.print context.output
        io.print "<< t#{info[0]}"

        separ = '('
        info[1].arguments.each do |arg|
          io.print separ
          separ = ','
          if parameters[arg]
            io.print parameters[arg]
          else
            io.print 'nil'
          end
        end

        io.print ')' if separ != '('
        io.puts
      end

      def setup( source)
        if m = /^['"]([a-z0-9_\-]+)['"]$/i.match( source.get)
          @target = m[1]
        else
          raise TranspilerError.new( @offset, 'Expected render target')
        end

        term = source.get
        case term
        when ','
          setup_comma_list( source, term)
        when 'with'
          setup_with( source)
        when 'for'
          @for = true
          setup_with( source)
        else
          term
        end
      end

      def setup_comma_list( source, term)
        while term == ','
          name = source.expect_name
          if source.get != ':'
            raise TranspilerError.new( @offset, 'Expected :')
          end
          @parameters[name], term = TranspilerExpression.parse( source)
        end
        term
      end

      def setup_with( source)
        expr, term = TranspilerExpression.parse( source)
        if term == 'as'
          name = source.expect_name
          term = source.get
        else
          name = @target
        end

        @parameters[name] = expr
        term
      end
    end
  end
end