require_relative '../test_base'

class TestConcat < TestBase
  def test_concat
    fire( <<CONCAT)
{% assign fruits = "apples, oranges, peaches" | split: ", " %}
{% assign vegetables = "carrots, turnips, potatoes" | split: ", " %}

{% assign everything = fruits | concat: vegetables %}

{% for item in everything %}
- {{ item }}
{% endfor %}
CONCAT
  end
end
