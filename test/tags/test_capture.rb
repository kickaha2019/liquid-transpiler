# frozen_string_literal: true

require_relative '../test_base'

class TestCapture < TestBase
  def test_capture
    compare(<<~CAPTURE)
      {% assign favorite_food = "pizza" %}
      {% assign age = 35 %}

      {% capture about_me %}
      I am {{ age }} and my favorite food is {{ favorite_food }}.
      {% endcapture %}

      {{ about_me }}
    CAPTURE
  end
end
