# frozen_string_literal: true
require_relative '../test_base'

class TestSort < TestBase
  def test_sort1
    compare(<<~SORT1)
      {% assign my_array = "zebra, octopus, giraffe, Sally Snake" | split: ", " %}
      
      {{ my_array | sort | join: ", " }}
    SORT1
  end

  def test_sort2
    compare(<<~SORT2, {'fruit' => [{'price' => 3, 'name' => 'Apple'}, {'price' => 2, 'name' => 'Banana'}]})
      {% assign fruit_by_price = fruit | sort: "price" %}
      {% for item in fruit_by_price %}
        <h4>{{ item.name }}</h4>
      {% endfor %}
    SORT2
  end
end
