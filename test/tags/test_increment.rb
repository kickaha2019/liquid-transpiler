# frozen_string_literal: true
require_relative '../test_base'

class TestIncrement < TestBase
  def test_increment1
    compare(<<~INCREMENT)
      {% assign var = 10 %}
      {% increment var %}
      {% increment var %}
      {% increment var %}
      {{ var }}
    INCREMENT
  end

  def test_increment2
    compare(<<~INCREMENT)
      {% increment var %}
      {% increment var %}
      {% decrement var %}
      {% decrement var %}
      {% decrement var %}
      {% increment var %}
      {% increment var %}
    INCREMENT
  end
end

