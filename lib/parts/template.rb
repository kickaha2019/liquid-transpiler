require_relative 'part'

module LiquidTranspiler
  module Parts
    class Template < Part
      class Names
        def initialize( names = {})
          @names = names
        end

        def assign( name)
          @names[name] = :local unless @names[name]
        end

        def local?( name)
          @names[name] == :local
        end

        def globals
          @names.keys.select {|name| @names[name] == :global}
        end

        def known( name)
          @names[name]
        end

        def names
          @names.each_key {|name| yield name}
        end

        def reference( name)
          @names[name] = :global unless @names[name]
        end

        def spawn
          Names.new( Hash.new {|h,k| h[k] = @names[k]})
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
        end.globals
      end
    end
  end
end
