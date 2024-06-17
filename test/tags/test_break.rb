# frozen_string_literal: true

require_relative '../test_base'

class TestBreak < TestBase
  def test_break
    compare(<<~BREAK)
      {% for i in (0..9) %}
      {{ i }}
      {% break %}
      {% endfor %}
    BREAK
  end
end
