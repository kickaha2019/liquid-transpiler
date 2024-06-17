# frozen_string_literal: true

require_relative '../test_base'

class TestLessThanOrEquals < TestBase
  def test_less_than_or_equals1
    compare(<<~LESS_THAN_OR_EQUALS)
      {% if 1 <= 2 and true %}
      Correct 6
      {% endif %}
    LESS_THAN_OR_EQUALS
  end
end
