# frozen_string_literal: true

require_relative '../test_base'

class TestAndOrs < TestBase
  def test_contains1
    compare(<<~CONTAINS1)
      {% assign title = "Gage Blackwood" %}
      {% if title contains "Gage" %}
        Agent 5
      {% endif %}
    CONTAINS1
  end

  def test_contains2
    compare(<<~CONTAINS2)
      {% assign names = "Gage Blackwood" | split: ' ' %}
      {% if names contains "Gage" %}
        Agent 5
      {% endif %}
    CONTAINS2
  end
end
