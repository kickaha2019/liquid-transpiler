require_relative '../test_base'

class TestSplit < TestBase
  def test_split
    compare(<<SPLIT)
{% assign beatles = "John, Paul, George, Ringo" | split: ", " %}

{% for member in beatles %}
  {{ member }}
{% endfor %}
SPLIT
  end
end
