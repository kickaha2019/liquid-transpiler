# frozen_string_literal: true
require_relative '../test_base'

class TestFirst < TestBase
  def test_first1
    compare(<<~FIRST)
      {{ "Ground control to Major Tom." | split: " " | first }}
    FIRST
  end

  def test_first2
    compare(<<~FIRST)
      {% assign my_array = "zebra, octopus, giraffe, tiger" | split: ", " %}
      {% if my_array.first == "zebra" %}
        Here comes a zebra!
      {% endif %}
    FIRST
  end
end
