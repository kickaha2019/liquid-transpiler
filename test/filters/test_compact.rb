# frozen_string_literal: true

require_relative '../test_base'

class TestCompact < TestBase
  def test_compact
    compare(<<~COMPACT, {'items' => [{'category' => 'A'}, {}, {'category' => 'B'}]})
      {% assign categories = items | map: "category" | compact %}
      
      {% for category in categories %}
      - {{ category }}
      {% endfor %}
    COMPACT
  end
end
