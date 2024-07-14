# frozen_string_literal: true

Dir["#{__dir__}/liquid_transpiler/*.rb"].each { |f| require f }
Dir["#{__dir__}/liquid_transpiler/operators/*.rb"].each { |f| require f }
Dir["#{__dir__}/liquid_transpiler/parts/*.rb"].each { |f| require f }

module LiquidTranspiler
  class Transpiler
    def initialize
      @signature = {}
      @parsed    = {}
      @errors    = []
      @filters   = {}
    end

    def define_filter(name, clazz)
      @filters[name.to_sym] = clazz
    end

    # rubocop:disable Style/ExplicitBlockArgument
    def errors
      @errors.each { |error| yield error }
    end
    # rubocop:enable Style/ExplicitBlockArgument

    def filter_class(name)
      @filters[name]
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
        @signature[name] = [index, ast.deduce_names(@globals)]
        index += 1
      end
    end

    def generate_ruby(path)
      context = Context.new(@globals, @signature, path)
      context.write_start(@clazz, @include)
      @signature.each_pair do |name, info|
        context.record(name, name)
        context.prepare(info[1])
        context.write_method_start(info)
        begin
          @parsed[name].record(context)
          @parsed[name].generate(context)
        rescue TranspilerError => e
          errors << e.message
        end
        context.write_method_end
      end
      context.write_records
      context.write_end
    end

    def parse(path)
      source  = Source.new(self, path)
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
      @include = options[:include] || 'LiquidTranspiledMethods'
      @globals = options[:globals] || []
    end
  end
end
