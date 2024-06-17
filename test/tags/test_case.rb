# frozen_string_literal: true
require_relative '../test_base'

class TestCase < TestBase
  def test_case
    compare(<<~CASE)
      {% case 2 %}
      {% when 1 %}Apple
      {% when 2 %}Banana
      {% endcase %}
    CASE
  end

  def test_case_else
    compare(<<~CASE_ELSE)
      {% case 2 %}
      {% when 1 %}Apple
      {% else %}Banana
      {% endcase %}
    CASE_ELSE
  end
end

