# frozen_string_literal: true

module LiquidTranspiler
  class Context
    def initialize(globals, signatures, path)
      @globals    = globals
      @signatures = signatures
      @io         = File.open(path, 'w')
      @line       = 1
      @records    = []
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
      [@variables[name], @fors[-1][1] || 'nil']
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

    def prepare(names)
      @variables  = {}
      @cycles     = {}
      @increments = {}

      @globals.each_index do |i|
        @variables[@globals[i].to_sym] = "@g#{i}"
      end

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

    def print(text)
      @io.print text
      @line += text.count("\n")
    end

    def puts(text = '')
      @io.puts text
      @line += (1 + text.count("\n"))
      @line -= 1 if text[-1] == "\n"
    end

    def record(reference, *data)
      @records << [reference, @line, *data]
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

    def write_end
      puts 'end'
      @io.close
    end

    def write_method_end
      puts <<"METHOD_END"
    h.join('')
  end
METHOD_END
    end

    def write_method_start(info)
      args = (0...info[1].arguments.size).collect { |i| "a#{i}" }.join(',')

      puts <<"METHOD_HEADER"
  def t#{info[0]}(#{args})
    h = []
METHOD_HEADER

      (0...info[1].cycles.size).each do |i|
        puts "    c#{i} = -1"
      end

      (0...info[1].increments.size).each do |i|
        puts "    d#{i} = 0"
      end
    end

    def write_records
      puts 'RECORDS = ['
      @records.each do |rec|
        if rec[2].is_a?(String)
          puts "[#{rec[1]},\"#{rec[2]}\"], # #{rec[0]}"
        else
          puts "[#{rec[1]},#{rec[2]},#{rec[3]}], # #{rec[0]}"
        end
      end
      puts '].freeze'
    end

    def write_start(clazz, include)
      puts <<~"START"
        class #{clazz}
          include #{include}
          TEMPLATES = {
      START

      @signatures.each_pair do |key, info|
        args = info[1].arguments.collect { |arg| "'#{arg}'" }.join(',')
        puts "  '#{key}' => [:t#{info[0]},[#{args}]],"
      end

      puts <<RENDER1
  }.freeze
  def render( name, params={})
    if info = TEMPLATES[name]
      begin
RENDER1

      @globals.each_index do |i|
        puts <<RENDER2
        @g#{i} = params['#{@globals[i]}']
RENDER2
      end

      puts <<RENDER3
        send( info[0], * info[1].collect {|arg| params[arg]})#{'  '}
      rescue StandardError => e
        raise liquify_exception(RECORDS,e)
      end
    else
      raise( 'Unknown template: ' + name)
    end
  end
  private
RENDER3
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
