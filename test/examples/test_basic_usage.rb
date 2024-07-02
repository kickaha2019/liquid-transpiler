# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/liquid_transpiler'
require_relative '../../lib/liquid_transpiled_methods'

class TestBasicUsage < Minitest::Test
  def setup
    @dir = ENV['TEMP_DIR'] || Dir.tmpdir
    Dir.entries(@dir).each do |f|
      if /\.(liquid|rb)$/ =~ f
        File.delete("#{@dir}/#{f}")
      end
    end
  end

  def test_basic_usage
    File.open( @dir + '/test1.liquid', 'w') do |io|
      io.puts <<"TEST1"
{% render 'test2', tree:tree %}
TEST1
    end

    File.open( @dir + '/test2.liquid', 'w') do |io|
      io.puts <<"TEST2"
There is a {{ tree }} tree in the Forest of {{ forest }}.
TEST2
    end

    transpiler = LiquidTranspiler::Transpiler.new
    status = transpiler.transpile_dir(
        @dir,
        "#{@dir}/fred.rb",
        {class:'Fred',  globals:['forest']})

    load( @dir + '/fred.rb')

    unless status
      transpiler.errors {|error| puts error}
      raise '*** Error transpiling'
    end

    fred   = Fred.new
    output = fred.render( 'test1', {'tree'=>'beech','forest'=>'Arden'})

    assert_equal 'There is a beech tree in the Forest of Arden.', output.strip
  end
end
