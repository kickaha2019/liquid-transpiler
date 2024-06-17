# frozen_string_literal: true

require_relative '../test_base'

class TestNotEquals < TestBase
  def test_not_equals1
    compare(<<~EMPTY, {'array' => [1]})
      {% if "" != empty %}
      Wrong
      {% endif %}
      {% if array != empty %}
      Right
      {% endif %}
      {% if array == empty %}
      Wrong
      {% endif %}
      {% if "A" != empty %}
      Right
      {% endif %}
    EMPTY
  end

  def test_not_equals2
    compare(<<~EMPTY, {'array' => [], 'letter' => 'A'})
      {% if 1 != 2 and true %}
      Correct 2
      {% endif %}
    EMPTY
  end
end
