# frozen_string_literal: true

require_relative '../test_base'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_date_to_long_string'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_transpiled_methods'

class TestDateToLongString < TestBase
  def test_date_to_long_string1
    gmt = Time.utc(2008, 11, 7)
    expect('{{ time | date_to_long_string }}',
           {'bridgetown' => {}, 'time' => gmt},
           '07 November 2008')
  end

  def test_date_to_long_string2
    gmt = Time.utc(2008, 11, 7)
    expect('{{ time | date_to_long_string: "ordinal" }}',
           {'bridgetown' => {}, 'time' => gmt},
           '7th November 2008')
  end

  def test_date_to_long_string3
    gmt = Time.utc(2008, 11, 7)
    expect('{{ time | date_to_long_string: "ordinal", "US" }}',
           {'bridgetown' => {}, 'time' => gmt},
           'November 7th, 2008')
  end

  def transpile(dir, path, clazz)
    @transpiler.define_filter('date_to_long_string',
                              LiquidTranspiler::Extensions::BridgetownDateToLongString)
    @transpiler.transpile_dir(dir,
                              path,
                              class:clazz,
                              include:'BridgetownTranspiledMethods',
                              globals:['bridgetown'])
  end
end
