# frozen_string_literal: true

require_relative '../test_base'

class TestDefault < TestBase
  def test_default1
    compare(<<~DEFAULT)
      {{ field1 | default: 2.99 }}
    DEFAULT
  end

  def test_default2
    compare(<<~DEFAULT)
      {% assign field2 = 4.99 %}
      {{ field2 | default: 2.99 }}
    DEFAULT
  end

  def test_default3
    compare(<<~DEFAULT)
      {% assign field3 = "" %}
      {{ field3 | default: 2.99 }}
    DEFAULT
  end

  def test_default4
    compare(<<~DEFAULT)
      {% assign field4 = false %}
      {{ field4 | default: true, allow_false: true }}
    DEFAULT
  end

  def test_default5
    compare(<<~DEFAULT, {'field5' => []})
      {{ field5 | default: 3.99 }}
    DEFAULT
  end
end
