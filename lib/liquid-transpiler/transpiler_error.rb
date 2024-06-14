module LiquidTranspiler
  class TranspilerError < Exception
    attr_reader :offset, :message

    def initialize( offset, message)
      @offset  = offset
      @message = message
    end
  end
end