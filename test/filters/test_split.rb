# frozen_string_literal: true
require_relative '../test_base'

class TestSplit < TestBase
  def test_split1
    compare(<<~SPLIT)
      {% assign beatles = "John, Paul, George, Ringo" | split: ", " %}
      
      {% for member in beatles %}
        {{ member }}
      {% endfor %}
    SPLIT
  end

  def test_split2
    compare(<<~SPLIT)
      {% assign odds = 12325 | split: 2 %}
      
      {% for member in odds %}
        {{ member }}
      {% endfor %}
    SPLIT
  end
end
