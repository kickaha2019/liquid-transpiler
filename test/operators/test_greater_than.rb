# frozen_string_literal: true
require_relative '../test_base'

class TestGreaterThan < TestBase
  def test_greater_than
    compare(<<~OPERATORS)
      {% if false or 1 > -1 %}
      Correct 3
      {% endif %}
    OPERATORS
  end
end

