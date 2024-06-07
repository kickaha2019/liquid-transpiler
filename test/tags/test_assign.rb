require_relative '../test_base'

class TestAssign < TestBase
  def test_assign1
    compare(<<ASSIGN1)
{% assign my_variable = "tomato" %}
{{ my_variable }}
ASSIGN1
  end
end

