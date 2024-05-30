module LiquidTranspiler
  module Operators
    class Leaf
      def initialize( token)
        @token = token
      end

      def find_arguments( names)
        if /^[a-z_]/i =~ @token
          names.reference( @token)
        end
      end

      def generate( context)
        (/^[a-z_]/i =~ @token) ? context.variable(@token) : @token
      end
    end
  end
end
