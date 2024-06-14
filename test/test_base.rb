require 'minitest/autorun'
require 'liquid'

require_relative '../lib/liquid-transpiler'
require_relative '../lib/liquid-transpiled-methods'

class TestBase < Minitest::Test
  PRODUCT_DATA = [{'type' => 'cupboard', 'title' => 'Vacuum',       'available' => true},
                  {'type' => 'kitchen',  'title' => 'Spatula',      'available' => false},
                  {'type' => 'lounge',   'title' => 'Television',   'available' => false},
                  {'type' => 'kitchen',  'title' => 'Garlic press', 'available' => true}]

  SITE_DATA    = [{'category' => 'business'},
                  {'category' => 'celebrities'},
                  {},
                  {'category' => 'lifestyle'},
                  {'category' => 'sports'},
                  {},
                  {'category' => 'technology'}]

  class BooleanDrop < Liquid::Drop
    def initialize(value)
      @value = value
    end

    def to_liquid
      @value
    end

    def to_s
      @value.to_s
    end
  end

  class ProductDrop < Liquid::Drop
    def initialize(product)
      @product = product
    end

    def type
      @product["type"]
    end

    def liquid_method_missing( method)
      if method == :title
        @product['title']
      else
        super( method)
      end
    end

    def available
      BooleanDrop.new( @product["available"])
    end
  end

  class ProductsDrop < Liquid::Drop
    def initialize( products)
      @products = products
    end

    def []( index)
      ProductDrop.new( @products[index])
    end

    def size
      @products.size
    end
  end

  @@transpiler  = LiquidTranspiler::LiquidTranspiler.new
  @@test_number = 0
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

  def compare(code, params = {})
    liquid         =  Liquid::Template.parse(code)
    liquid_output  =  liquid.render( params)
    prepare( code, 'test.liquid')
    @@test_number  += 1
    clazz          =  "Temp#{@@test_number}"
    path           = @@dir + '/Test.rb'
    if @@transpiler.transpile_dir( @@dir, path, class:clazz)
      load( path)
      transpiled_output = Object.const_get(clazz).new.render( 'test', params)
      p ['liquid_output', liquid_output]
      p ['transpiled_output', transpiled_output]
      assert_equal liquid_output, transpiled_output
    else
      @@transpiler.errors {|error| puts error}
      raise 'Transpiler errors'
    end
  end

  def expect( code, params = {}, expected)
    prepare( code, 'test.liquid')
    @@test_number  += 1
    clazz          =  "Temp#{@@test_number}"
    path           = @@dir + '/Test.rb'
    if @@transpiler.transpile_dir( @@dir, path, class:clazz)
      load( path)
      transpiled_output = Object.const_get(clazz).new.render( 'test', params)
      p ['transpiled_output', transpiled_output]
      assert_equal expected, transpiled_output.strip
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

  def poro_products
    PRODUCT_DATA
  end

  def poro_sites
    SITE_DATA
  end
end
