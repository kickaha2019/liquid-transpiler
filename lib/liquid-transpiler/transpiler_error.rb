module LiquidTranspiler
  class TranspilerError < Exception
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end
end
