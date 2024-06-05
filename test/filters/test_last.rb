require_relative '../test_base'

class TestLast < TestBase
  def test_last1
    compare(<<LAST)
{{ "Ground control to Major Tom." | split: " " | last }}
LAST
  end

  def test_last2
    compare(<<LAST)
{% assign my_array = "zebra, octopus, giraffe, tiger" | split: ", " %}
{{ my_array.last }}

{% if my_array.last == "tiger" %}
  There goes a tiger!
{% endif %}
LAST
  end
end
