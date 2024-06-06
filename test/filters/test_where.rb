require_relative '../test_base'

class TestWhere < TestBase
  def test_where
    compare(<<URL_WHERE, {'products' => poro_products})
{% assign kitchen_products = products | where: "type", "kitchen" %}

Kitchen products:
{% for product in kitchen_products %}
- {{ product.name }}
{% endfor %}

{% assign available_products = products | where: "available" %}

Available products:
{% for product in available_products %}
- {{ product.name }}
{% endfor %}

First kitchen product:
- {{ products | where: "type", "kitchen" | first }}
URL_WHERE
  end
end
