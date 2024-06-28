# frozen_string_literal: true

require_relative '../test_base'

class TestObject < TestBase
  def test_object1
    compare('{{ hash.array[0] }}', {'hash' => {'array' => ['Hello World']}})
  end

  def test_object2
    compare('{{ hash.array[0].field }}',
            {'hash' => {'array' => [{'field' => 'Hello World'}]}})
  end

  def test_object5
    compare('{{ "Hello World" }}')
  end

  def test_global1
    prepare(<<~GLOBAL1, 'site.liquid')
      {{- site -}}
    GLOBAL1
    expect(<<~GLOBAL1, {'site' => "Peter's pages"}, "Peter's pages")
      {% render 'site' %}
    GLOBAL1
  end

  def test_global2
    expect_code(<<~GLOBAL2, /def t0\(\)/)
      {{ site }}
    GLOBAL2
  end
end
