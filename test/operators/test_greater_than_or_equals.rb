# frozen_string_literal: true

require_relative '../test_base'

class TestGreaterThanOrEquals < TestBase
  def test_greater_than_or_equals
    compare(<<~OPERATORS)
      {% if false or 1 >= -1 %}
      Correct 5
      {% endif %}
    OPERATORS
  end
end
