module LiquidTranspiler
  module Operators
    class Leaf
      SPECIALS = {'true' => 'true', 'false' => 'false', 'empty' => ':empty'}
      attr_reader :token

      def initialize( token)
        @token = token
      end

      def find_arguments( names)
        if (/^[a-z_]/i =~ @token) && (! SPECIALS[@token])
          names.reference( @token)
        end
      end

      def generate( context)
        return SPECIALS[@token] if SPECIALS[@token]
        (/^[a-z_]/i =~ @token) ? context.variable(@token) : @token
      end
    end
  end
end
