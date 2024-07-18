# frozen_string_literal: true

require_relative '../test_base'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_date_to_xmlschema'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_transpiled_methods'

class TestDateToXMLSchema < TestBase
  def test_date_to_xml_schema1
    gmt = Time.utc(2000, 12, 1, 7, 40, 30)
    expect('{{ time | date_to_xmlschema }}',
           {'bridgetown' => {}, 'time' => gmt},
           '2000-12-01T07:40:30+00:00')
  end

  def test_date_to_xml_schema2
    expect('{{ "1st December 2000" | date_to_xmlschema }}',
           {'bridgetown' => {'timezone' => 'America/Los_Angeles'}},
           '2000-12-01T00:00:00-08:00')
  end

  def transpile(dir,path,clazz)
    @transpiler.define_filter('date_to_xmlschema',
                              LiquidTranspiler::Extensions::BridgetownDateToXMLSchema)
    @transpiler.transpile_dir(dir,
                              path,
                              class:clazz,
                              include:'BridgetownTranspiledMethods',
                              globals:['bridgetown'])
  end
end
