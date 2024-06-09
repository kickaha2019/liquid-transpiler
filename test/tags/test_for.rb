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

  def test_for_limit
    compare(<<FOR_LIMIT, {'array' => [1, 2, 3, 4, 5, 6]})
{% for item in array limit:2 %}
  {{ item }}
{% endfor %}
FOR_LIMIT
  end

  def test_for_offset1
    compare(<<FOR_OFFSET1, {'array' => [1, 2, 3, 4, 5, 6]})
{% for item in array offset:2 %}
  {{ item }}
{% endfor %}
FOR_OFFSET1
  end

#   def test_for_offset2
#     compare(<<FOR_OFFSET2, {'array' => [1, 2, 3, 4, 5, 6]})
# {% for item in array limit:3 %}
#   {{ item }}
# {% endfor %}
# {% for item in array limit: 3 offset: continue %}
#   {{ item }}
# {% endfor %}
# FOR_OFFSET2
#   end

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

  def test_for_reversed
    compare(<<FOR_LIMIT, {'array' => [1, 2, 3, 4, 5, 6]})
{% for item in array reversed %}
  {{ item }}
{% endfor %}
FOR_LIMIT
  end

  def test_for_reversed_limit
    compare(<<FOR_LIMIT, {'array' => [1, 2, 3, 4, 5, 6]})
{% for item in array reversed limit:2 %}
  {{ item }}
{% endfor %}
FOR_LIMIT
  end

  def test_for_forloop
    compare(<<FORLOOP, {'array1' => [1], 'array2' => [1, 2]})
{% for item1 in array1 %}
  {% for item2 in array2 %}
    parent length {{ forloop.parentloop.length }}
    length {{ forloop.length }}
    index {{ forloop.index }}
    index0 {{ forloop.index0 }}
    rindex {{ forloop.rindex }}
    rindex0 {{ forloop.rindex0 }}
    first {{ forloop.first }}
    last {{ forloop.last }}
  {% endfor %}
{% endfor %}
FORLOOP
  end
end

