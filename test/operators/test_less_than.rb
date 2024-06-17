# frozen_string_literal: true
require_relative '../test_base'

class TestLessThan < TestBase
  def test_less_than
    compare(<<~OPERATORS)
      {% if 1 < 2 and true %}
      Correct 4
      {% endif %}
    OPERATORS
  end
end

