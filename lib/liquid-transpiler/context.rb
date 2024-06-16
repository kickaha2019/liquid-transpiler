module LiquidTranspiler
  class Context
    def initialize(signatures, names)
      @signatures = signatures
      @variables  = {}
      @cycles     = {}
      @increments = {}

      arguments = names.arguments
      (0...arguments.size).each do |i|
        @variables[arguments[i]] = "a#{i}"
      end

      cycles = names.cycles
      (0...cycles.size).each do |i|
        @cycles[cycles[i]] = "c#{i}"
      end

      increments = names.increments
      (0...increments.size).each do |i|
        @increments[increments[i]] = "d#{i}"
      end

      @output    = ['h']
      @fors      = []
      @index     = 0
      @tablerows = []
    end

    def cycle(name)
      @cycles[name]
    end

    def endfor(name)
      f = @fors.pop
      @variables[name]     = f[0]
      @variables[:forloop] = f[1]
    end

    def endtablerow(name)
      f = @tablerows.pop
      @variables[name]          = f[0]
      @variables[:tablerowloop] = f[1]
    end

    def for(name)
      @fors << [@variables[name], @variables[:forloop]]
      @variables[name]     = "for#{@fors.size}"
      @variables[:forloop] = "for#{@fors.size}l"
      return @variables[name], (@fors[-1][1] ? @fors[-1][1] : 'nil')
    end

    def increment(name)
      @increments[name]
    end

    def output
      @output[-1]
    end

    def output_pop
      @output.pop
    end

    def output_push
      @output << "h#{@output.size + 1}"
    end

    def signature(name)
      @signatures[name]
    end

    def tablerow(name)
      @tablerows << [@variables[name], @variables[:tablerowloop]]
      @variables[name]          = "tablerow#{@tablerows.size}"
      @variables[:tablerowloop] = "tablerow#{@tablerows.size}l"
      @variables[name]
    end

    def variable(name)
      unless @variables[name]
        @index += 1
        @variables[name] = "v#{@index}"
      end
      @variables[name]
    end
  end
end
