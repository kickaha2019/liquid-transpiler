require_relative 'transpiler_requires'

module LiquidTranspiler
  class Transpiler
    def initialize
      @signature = {}
      @parsed    = {}
      @errors    = []
    end

    def errors
      @errors.each {|error| yield error}
    end

    def transpile_dir( source_dir, clazz, path)
      @errors = []
      parse_dir( source_dir)
      return false unless @errors.empty?
      deduce_signatures
      generate_ruby( clazz, path)
      @errors.empty?
    end

    private

    def deduce_signatures
      index = 0
      @parsed.each_pair do |name, ast|
        @signature[name] = [index, ast.deduce_names]
        index += 1
      end
    end

    def generate_ruby( clazz, path)
      File.open( path, 'w') do |io|
        write_start( clazz, io)
        @signature.each_pair do |name, info|
          write_method_start( info, io)
          @parsed[name].generate( TranspilerContext.new( info[1]), 4, io)
          write_method_end( io)
        end
        io.puts 'end'
      end
    end

    def parse( path)
      source  = TranspilerSource.new( path)
      context = Parts::Template.new
      rstrip  = false

      begin
        until source.eof?
          part, rstrip = context.digest( source, rstrip)
          context = context.add part
        end

        context.add( Parts::EndOfFile.new( source.offset))
      rescue TranspilerError => bang
        @errors << "#{bang.message} [#{path}:#{source.line_number( bang.offset)}]"
      end
    end

    def parse_dir( source_dir)
      @parsed = {}
      Dir.entries( source_dir).each do |f|
        if m = /^(.*)\.liquid$/.match( f)
          @parsed[m[1]] = parse( source_dir + '/' + f)
        end
      end
    end

    def write_method_end( io)
      io.puts <<"METHOD_END"
    h.join('')
  end
METHOD_END
    end

    def write_method_start( info, io)
      args = (0...info[1].arguments.size).collect {|i| "a#{i}"}.join(',')

      io.puts <<"METHOD_HEADER"
  def t#{info[0]}(#{args})
    h = []
METHOD_HEADER

      (0...info[1].cycles.size).each do |i|
        io.puts "    c#{i} = -1"
      end

      (0...info[1].decrements.size).each do |i|
        io.puts "    d#{i} = 0"
      end
    end

    def write_start( clazz, io)
      io.puts <<"START"
class #{clazz}
  include TranspiledMethods
  TEMPLATES = {
START
      @signature.each_pair do |key, info|
        args = info[1].arguments.collect {|arg| "'#{arg}'"}.join(',')
        io.puts "  '#{key}' => [:t#{info[0]},[#{args}]],"
      end
      io.puts <<RENDER
  }
  def render( name, params={})
    if info = TEMPLATES[name]
      send( info[0], * info[1].collect {|arg| params[arg]})  
    else
      raise( 'Unknown template: ' + name)
    end
  end
  private
RENDER
    end
  end
end