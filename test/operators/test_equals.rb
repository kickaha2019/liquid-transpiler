# frozen_string_literal: true

require_relative '../test_base'

class TestEquals < TestBase
  def test_equals1
    compare(<<~EMPTY, {'array' => [], 'letter' => 'A'})
      {% if "" == empty %}
      Empty string
      {% endif %}
      {% if array == empty %}
      Empty array
      {% endif %}
      {% if "A" == letter %}
      Was an A
      {% endif %}
      {% if letter == 'b' %}
      {% else %}
      Wasn't a b
      {% endif %}
    EMPTY
  end

  def test_equals2
    compare(<<~EMPTY, {'array' => [], 'letter' => 'A'})
      {% if false or 1 == 1 %}
      Correct 1
      {% endif %}
    EMPTY
  end
end
