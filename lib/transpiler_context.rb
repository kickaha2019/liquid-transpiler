module LiquidTranspiler
  class TranspilerContext
    def initialize( names)
      @variables  = {}
      @cycles     = {}
      @decrements = {}

      arguments = names.arguments
      (0...arguments.size).each do |i|
        @variables[arguments[i]] = "a#{i}"
      end

      cycles = names.cycles
      (0...cycles.size).each do |i|
        @cycles[cycles[i]] = "c#{i}"
      end

      decrements = names.decrements
      (0...decrements.size).each do |i|
        @decrements[decrements[i]] = "d#{i}"
      end

      @output = ['h']
      @fors   = []
      @index  = 0
    end

    def cycle( name)
      @cycles[name]
    end

    def decrement( name)
      @decrements[name]
    end

    def endfor( name)
      f = @fors.pop
      @variables[name]      = f[0]
      @variables['forloop'] = f[1]
    end

    def for( name)
      @fors << [@variables[name], @variables['forloop']]
      @variables[name]      = "f#{@fors.size}"
      @variables['forloop'] = "f#{@fors.size}l"
      return @variables[name], (@fors[-1][1] ? @fors[-1][1] : 'nil')
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