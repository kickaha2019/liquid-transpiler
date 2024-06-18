# frozen_string_literal: true

require_relative 'liquid-transpiler/requires'

module LiquidTranspiler
  class LiquidTranspiler
    def initialize
      @signature = {}
      @parsed    = {}
      @errors    = []
    end

    def errors
      @errors.each { |error| yield error }
    end

    def transpile_dir(source_dir, path, options = {})
      process_options(options)
      @errors = []
      parse_dir(source_dir)
      return false unless @errors.empty?

      deduce_signatures
      generate_ruby(path)
      @errors.empty?
    end

    private

    def deduce_signatures
      @signature = {}
      index = 0
      @parsed.each_pair do |name, ast|
        @signature[name] = [index, ast.deduce_names]
        index += 1
      end
    end

    def generate_ruby(path)
      File.open(path, 'w') do |io|
        write_start(io)
        @signature.each_pair do |name, info|
          write_method_start(info, io)
          context = Context.new(@signature, info[1])
          begin
            @parsed[name].generate(context, 4, io)
          rescue TranspilerError => e
            errors << e.message
          end
          write_method_end(io)
        end
        io.puts 'end'
      end
    end

    def parse(path)
      source  = Source.new(path)
      context = Parts::Template.new(source, 0, nil)
      rstrip  = false

      begin
        until source.eof?
          part, rstrip = context.digest(source, rstrip)
          context = context.add part if part
        end

        context.add(Parts::EndOfFile.new(source, source.offset, nil))
      rescue TranspilerError => e
        errors << e.message
      end
    end

    def parse_dir(source_dir)
      @parsed = {}
      Dir.entries(source_dir).each do |f|
        if m = /^(.*)\.liquid$/.match(f)
          @parsed[m[1]] = parse("#{source_dir}/#{f}")
        end
      end
    end

    def process_options(options)
      @clazz   = options[:class]   || 'Transpiled'
      @include = options[:include] || 'TranspiledMethods'
    end

    def write_method_end(io)
      io.puts <<"METHOD_END"
    h.join('')
  end
METHOD_END
    end

    # rubocop:disable Metrics/AbcSize
    def write_method_start(info, io)
      args = (0...info[1].arguments.size).collect { |i| "a#{i}" }.join(',')

      io.puts <<"METHOD_HEADER"
  def t#{info[0]}(#{args})
    h = []
METHOD_HEADER

      (0...info[1].cycles.size).each do |i|
        io.puts "    c#{i} = -1"
      end

      (0...info[1].increments.size).each do |i|
        io.puts "    d#{i} = 0"
      end
    end
    # rubocop:enable Metrics/AbcSize

    def write_start(io)
      io.puts <<~"START"
        class #{@clazz}
          include #{@include}
          TEMPLATES = {
      START
      @signature.each_pair do |key, info|
        args = info[1].arguments.collect { |arg| "'#{arg}'" }.join(',')
        io.puts "  '#{key}' => [:t#{info[0]},[#{args}]],"
      end
      io.puts <<RENDER
  }
  def render( name, params={})
    if info = TEMPLATES[name]
      send( info[0], * info[1].collect {|arg| params[arg]})#{'  '}
    else
      raise( 'Unknown template: ' + name)
    end
  end
  private
RENDER
    end
  end
end
