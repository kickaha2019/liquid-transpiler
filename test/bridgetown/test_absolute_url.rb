# frozen_string_literal: true

require_relative '../test_base'

class TestAbsoluteURL < TestBase
  def test_absolute_url
    expect('{{ "/assets/image.jpg" | absolute_url }}',
           {'bridgetown' => {'base_path' => '/my-basepath', 'url' => 'http://example.com'}},
           'http://example.com/my-basepath/assets/image.jpg')
  end

  def transpile(dir,path,clazz)
    @transpiler.define_filter('absolute_url', LiquidTranspiler::Extensions::BridgetownAbsoluteURL)
    @transpiler.transpile_dir(dir, path, class:clazz, globals:['bridgetown'])
  end
end
