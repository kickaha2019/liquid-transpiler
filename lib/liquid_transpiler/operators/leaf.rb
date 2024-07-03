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

        if @token.is_a?(Symbol)
          context.variable(@token)
        elsif @token.is_a?(String)
          context.string(@token)
        else
          @token.to_s
        end
      end
    end
  end
end
