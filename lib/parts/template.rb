require_relative 'part'

module LiquidTranspiler
  module Parts
    class Template < Part
      class Names
        def initialize( arguments = {}, variables = {})
          @arguments = arguments
          @variables = variables
          @locals    = {}
        end

        def arguments
          @arguments.keys
        end

        def assign( name)
          @variables[name] = true unless known?( name)
        end

        def known?( name)
          @arguments[name] || @variables[name]
        end

        def local?( name)
          @locals[name]
        end

        def locals
          @locals.each_key {|name| yield name}
        end

        def reference( name)
          @arguments[name] = true unless known?( name)
        end

        def spawn
          Names.new( @arguments, Hash.new {|h,k| h[k] = @variables[k]})
        end
      end

      def initialize
        super( 0)
      end

      def add( part)
        @children << part
        clazz = part.class.name.split('::')[-1]

        case clazz
        when 'Embedded'
          return self
        when 'EndOfFile'
          return self
        when 'TagAssign'
          return self
        else
          raise TranspilerError.new( part.offset, 'Unexpected tag')
        end
      end

      def deduce_arguments
        Names.new().tap do |names|
          find_arguments( names)
        end.arguments
      end
    end
  end
end
