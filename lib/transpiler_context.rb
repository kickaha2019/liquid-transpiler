module LiquidTranspiler
  class TranspilerContext
    def initialize( arguments)
      @variables = {}
      (0...arguments.size).each do |i|
        @variables[arguments[i]] = "a#{i}"
      end

      @output = ['h']
      @index  = 0
    end

    def output
      @output[-1]
    end

    def variable( name)
      unless @variables[name]
        @index += 1
        @variables[name] = "v#{@index}"
      end
      @variables[name]
    end
  end
end