require 'minitest/autorun'
require 'liquid'

require_relative '../lib/transpiler'
require_relative '../lib/transpiled_methods'

class TestBase < Minitest::Test
  @@transpiler  = LiquidTranspiler::Transpiler.new
  @@dir         = ENV['TEMP_DIR'] ? ENV['TEMP_DIR'] : Dir.tmpdir
  Liquid::Template.file_system = Liquid::LocalFileSystem.new( @@dir,
                                                              pattern = "%s.liquid")
  Liquid.cache_classes = false

  def setup
    Dir.entries( @@dir).each do |f|
      if /\.liquid$/ =~ f
        File.delete( @@dir + '/' + f)
      end
    end
  end

  def fire( code, params = {})
    liquid         =  Liquid::Template.parse(code)
    liquid_output  =  liquid.render( params)
    prepare( code, 'test.liquid')
    clazz          =  "Temp"
    path           = @@dir + '/' + clazz + '.rb'
    if @@transpiler.transpile_dir( @@dir, clazz, path)
      load( path)
      transpiled_output = Object.const_get(clazz).new.render( 'test', params)
      assert_equal liquid_output, transpiled_output
    else
      @@transpiler.errors {|error| puts error}
      raise 'Transpiler errors'
    end
  end

  def prepare( code, path)
    File.open( @@dir + '/' + path, 'w') do |io|
      io.print code
    end
  end
end
