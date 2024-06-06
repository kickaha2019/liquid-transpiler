require_relative '../test_base'

class TestEquals < TestBase
  def test_equals
    compare(<<EMPTY, {'array' => [], 'letter' => 'A'})
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
end

