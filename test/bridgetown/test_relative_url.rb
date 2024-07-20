# frozen_string_literal: true

require_relative '../test_base'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_relative_url'

class TestRelativeURL < TestBase
  def test_relative_url
    expect('{{ "/assets/image.jpg" | relative_url }}',
           {'bridgetown' => {'base_path' => '/xxx'}},
           '/xxx/assets/image.jpg')
  end

  def transpile(dir, path, clazz)
    @transpiler.define_filter('relative_url', LiquidTranspiler::Extensions::BridgetownRelativeURL)
    @transpiler.transpile_dir(dir, path, class:clazz, globals:['bridgetown'])
  end
end
