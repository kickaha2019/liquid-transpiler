# frozen_string_literal: true

require_relative '../test_base'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_date_to_string'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_transpiled_methods'

class TestDateToString < TestBase
  def test_date_to_string1
    gmt = Time.utc(2008, 11, 7)
    expect('{{ time | date_to_string }}',
           {'bridgetown' => {}, 'time' => gmt},
           '07 Nov 2008')
  end

  def test_date_to_string2
    gmt = Time.utc(2008, 11, 7)
    expect('{{ time | date_to_string: "ordinal" }}',
           {'bridgetown' => {}, 'time' => gmt},
           '7th Nov 2008')
  end

  def test_date_to_string3
    gmt = Time.utc(2008, 11, 7)
    expect('{{ time | date_to_string: "ordinal", "US" }}',
           {'bridgetown' => {}, 'time' => gmt},
           'Nov 7th, 2008')
  end

  def transpile(dir, path, clazz)
    @transpiler.define_filter('date_to_string',
                              LiquidTranspiler::Extensions::BridgetownDateToString)
    @transpiler.transpile_dir(dir,
                              path,
                              class:clazz,
                              include:'BridgetownTranspiledMethods',
                              globals:['bridgetown'])
  end
end
