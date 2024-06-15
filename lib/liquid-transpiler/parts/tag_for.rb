module LiquidTranspiler
  module Parts
    class TagFor < Part
      def initialize( source, offset, parent)
        super
        @else     = nil
        @limit    = nil
        @reversed = false
        @start    = nil
        @variable = source.expect_name
        token     = source.get

        unless token == :in
          source.error( @offset, 'Expecting in')
        end

        @expression, term = Expression.parse( source)

        while true
          case term
          when :limit
            if source.get != ':'
              source.error( @offset, 'Expected : after limit')
            end
            @limit, term = Expression.parse( source)
          when :reversed
            @reversed = true
            term = source.get
          when :offset
            if source.get != ':'
              source.error( @offset, 'Expected : after offset')
            end
            @start, term = Expression.parse( source)
          else
            break
          end
        end

        source.unget term
      end

      def add( part)
        if part.is_a?( TagBreak)
          @children << part
          return self
        end
        if part.is_a?( TagElse)
          @else = part
          return part
        end
        if part.is_a?( TagEndfor)
          return @parent
        end
        super( part)
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        @limit.find_arguments( names) if @limit
        @start.find_arguments( names) if @start
        names = names.spawn
        names.assign( @variable)
        names.assign( 'forloop')
        super( names)
      end

      def generate( context, indent, io)
        io.print ' ' * indent
        for_name, old_for_loop = context.for( @variable)
        io.puts "#{for_name}l = f(#{@expression.generate( context)},#{old_for_loop})"

        if @start
          io.print ' ' * indent
          io.puts "#{for_name}l.offset #{@start.generate( context)}"
        end

        if @limit
          io.print ' ' * indent
          io.puts "#{for_name}l.limit #{@limit.generate( context)}"
        end

        if @reversed
          io.print ' ' * indent
          io.puts "#{for_name}l.reverse"
        end

        if @else
          io.print ' ' * indent
          io.puts "unless #{for_name}l.empty?"
          indent += 2
        end

        io.print ' ' * indent
        io.puts "#{for_name}l.each do |#{for_name}|"
        super( context, indent+2, io)
        io.print ' ' * indent
        io.puts 'end'

        if @else
          indent -= 2
          @else.generate( context, indent+2, io)
          io.print ' ' * indent
          io.puts "end"
        end

        context.endfor( @variable)
      end
    end
  end
end