require_relative '../test_base'

class TestNotEquals < TestBase
  def test_not_equals
    compare(<<EMPTY, {'array' => [1]})
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
end

