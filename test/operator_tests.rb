require_relative 'test_base'

class OperatorTests < TestBase
  def test_operators
    compare(<<OPERATORS)
{% false or 1 == 1 %}
Correct 1
{% endif %}
{% 1 != 2 and true %}
Correct 2
{% endif %}
{% false or 1 > -1 %}
Correct 3
{% endif %}
{% 1 < 2 and true %}
Correct 4
{% endif %}
{% false or 1 >= -1 %}
Correct 5
{% endif %}
{% 1 <= 2 and true %}
Correct 6
{% endif %}
OPERATORS
  end
end
