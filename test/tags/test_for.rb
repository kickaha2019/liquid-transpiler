require_relative '../test_base'

class TestFor < TestBase
  def test_for
    compare(<<FOR, {'basket' => ['Apple']})
{% for fruit in basket %}
{{ fruit }}
{% endfor %}
FOR
  end

  def test_for_else
    compare(<<FOR, {'basket' => []})
{% for fruit in basket %}
{{ fruit }}
{% else %}
Empty basket
{% endfor %}
FOR
  end

  def test_for_range
    compare(<<FOR_RANGE)
{% for i in (3..5) %}
  {{ i }}
{% endfor %}

{% assign num = 4 %}
{% assign range = (1..num) %}
{% for i in range %}
  {{ i }}
{% endfor %}
FOR_RANGE
  end

end

