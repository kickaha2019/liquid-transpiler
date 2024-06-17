# frozen_string_literal: true
require_relative '../test_base'

class TestCycle < TestBase
  def test_cycle1
    compare(<<~CYCLE, {'basket' => ['Apple', 'Banana']})
      {% for fruit in basket %}
        {% cycle "one", "two", "three" %}
        {% cycle "one", "two", "five" %}
        {% cycle "special": "one", "two", "three" %}
        {% cycle "special": "one", "two", "six" %}
      {% endfor %}
    CYCLE
  end

  def test_cycle2
    compare(<<~CYCLE, {'basket' => ['Apple', 'Banana']})
      {% cycle "one", "two", "three" %}
      {% cycle "one", "two", "three" %}
      {% cycle "one", "two", "three" %}
      {% cycle "one", "two", "three" %}
    CYCLE
  end

  def test_cycle3
    compare(<<~CYCLE, {'basket' => ['Apple', 'Banana']})
      {% cycle "first": "one", "two", "three" %}
      {% cycle "second": "one", "two", "three" %}
      {% cycle "second": "one", "two", "three" %}
      {% cycle "first": "one", "two", "three" %}
    CYCLE
  end

  def test_cycle4
    compare(<<~CYCLE, {'basket' => ['Apple', 'Banana']})
      {% cycle 1, 2, 3 %}
      {% cycle 1, 2, 6 %}
    CYCLE
  end

  def test_cycle5
    compare(<<~CYCLE, {'basket' => 'Apple'})
      {% cycle a: basket %}
    CYCLE
  end
end

