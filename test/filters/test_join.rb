# frozen_string_literal: true

require_relative '../test_base'

class TestJoin < TestBase
  def test_join
    compare(<<~JOIN)
      {% assign beatles = "John, Paul, George, Ringo" | split: ", " %}
      
      {{ beatles | join: " and " }}
    JOIN
  end
end
