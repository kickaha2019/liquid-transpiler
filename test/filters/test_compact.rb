require_relative '../test_base'

class TestCompact < TestBase
  def test_compact
    fire( <<COMPACT, {'items' => [{'category' => 'A'},{},{'category' => 'B'}]})
{% assign categories = items | map: "category" | compact %}

{% for category in categories %}
- {{ category }}
{% endfor %}
COMPACT
  end
end
