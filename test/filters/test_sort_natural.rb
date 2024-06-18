# frozen_string_literal: true

require_relative '../test_base'

class TestSortNatural < TestBase
  def test_sort_natural1
    compare(<<~SORT1)
      {% assign my_array = "zebra, octopus, giraffe, Sally Snake" | split: ", " %}

      {{ my_array | sort_natural | join: ", " }}
    SORT1
  end

  def test_sort_natural2
    compare(<<~SORT2, {'animals' => [{'name' => 'zebra'}, {'name' => 'Sally Snake'}]})
      {% assign animals_by_name = animals | sort_natural: "name" %}
      {% for animal in animals_by_name %}
        <h4>{{ animal.name }}</h4>
      {% endfor %}
    SORT2
  end
end
