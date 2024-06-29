# frozen_string_literal: true

module LiquidTranspiler
  module Operators
    class Leaf
      SPECIALS = { true: 'true', false: 'false', empty: ':empty' }.freeze
      attr_reader :token

      def initialize(token)
        @token = token
      end

      def find_arguments(names)
        if @token.is_a?(Symbol) && (!SPECIALS[@token])
          names.reference(@token)
        end
      end

      def generate(context)
        return SPECIALS[@token] if SPECIALS[@token]

        @token.is_a?(Symbol) ? context.variable(@token) : @token
      end
    end
  end
end
