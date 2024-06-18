# frozen_string_literal: true

module LiquidTranspiler
  class TranspilerError < StandardError
    attr_reader :message

    def initialize(message)
      super()
      @message = message
    end
  end
end
