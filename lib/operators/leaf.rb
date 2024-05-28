module LiquidTranspiler
  module Operators
    class Leaf
      def initialize( token)
        @token = token
      end

      def deduce_arguments
        (/^[a-z_]/i =~ @token) ? [@token] : []
      end

      def generate( arguments)
        (/^[a-z_]/i =~ @token) ? arguments[@token] : @token
      end
    end
  end
end
