# frozen_string_literal: true

require_relative '../test_base'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_date_to_rfc822'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_transpiled_methods'

class TestDateToRFC822 < TestBase
  def test_date_to_rfc1
    gmt = Time.utc(2008, 11, 7, 13, 7, 54)
    expect('{{ time | date_to_rfc822 }}',
           {'bridgetown' => {}, 'time' => gmt},
           'Fri, 07 Nov 2008 13:07:54 +0000')
  end

  def test_date_to_rfc2
    expect('{{ "7th November 2008 13:07:54" | date_to_rfc822 }}',
           {'bridgetown' => {'timezone' => 'America/Los_Angeles'}},
           'Fri, 07 Nov 2008 13:07:54 -0800')
  end

  def transpile(dir, path, clazz)
    @transpiler.define_filter('date_to_rfc822',
                              LiquidTranspiler::Extensions::BridgetownDateToRFC822)
    @transpiler.transpile_dir(dir,
                              path,
                              class:clazz,
                              include:'BridgetownTranspiledMethods',
                              globals:['bridgetown'])
  end
end
