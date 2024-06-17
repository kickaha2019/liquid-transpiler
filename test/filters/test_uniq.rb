# frozen_string_literal: true

require_relative '../test_base'

class TestUniq < TestBase
  def test_uniq
    compare(<<~UNIQ)
      {% assign my_array = "ants, bugs, bees, bugs, ants" | split: ", " %}
      
      {{ my_array | uniq | join: ", " }}
    UNIQ
  end
end
