require_relative '../test_base'

class TestContinue < TestBase
  def test_continue
    compare(<<CONTINUE)
{% for i in (1..5) %}
  {% if i == 4 %}
    {% continue %}
  {% else %}
    {{ i }}
  {% endif %}
{% endfor %}
CONTINUE
  end
end

