# frozen_string_literal: true

require_relative '../test_base'

class TestDecrement < TestBase
  def test_decrement
    compare(<<~DECREMENT)
      {% assign var = 10 %}
      {% decrement var %}
      {% decrement var %}
      {% decrement var %}
      {{ var }}
    DECREMENT
  end
end
