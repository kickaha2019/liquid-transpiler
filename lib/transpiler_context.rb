module LiquidTranspiler
  class TranspilerContext
    def initialize( names)
      @variables = {}
      @cycles    = {}

      arguments = names.arguments
      (0...arguments.size).each do |i|
        @variables[arguments[i]] = "a#{i}"
      end

      cycles = names.cycles
      (0...cycles.size).each do |i|
        @cycles[cycles[i]] = "c#{i}"
      end

      @output = ['h']
      @index  = 0
    end

    def cycle( name)
      @cycles[name]
    end

    def output
      @output[-1]
    end

    def output_pop
      @output.pop
    end

    def output_push
      @output << "h#{@output.size+1}"
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