# frozen_string_literal: true
require_relative '../test_base'

class TestSlice < TestBase
  def test_slice1
    compare(<<~SLICE)
      {{ "Liquid" | slice: 0 }}
      {{ "Liquid" | slice: 2 }}
      {{ "Liquid" | slice: 2, 5 }}
      {{ "Liquid" | slice: -3, 2 }}
    SLICE
  end

  def test_slice2
    compare(<<~SLICE)
      {% assign beatles = "John, Paul, George, Ringo" | split: ", " %}
      {{ beatles | slice: 0 }}
      {{ beatles | slice: 1, 2 }}
      {{ beatles | slice: -2, 2 }}
    SLICE
  end
end
