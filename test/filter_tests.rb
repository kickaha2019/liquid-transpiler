require_relative 'test_base'

class FilterTests < TestBase
  def test_where
    products = [{'name' => 'Vacuum', 'room' => 'lounge', 'available' => true},
                {'name' => 'Spatula', 'room' => 'kitchen', 'available' => false},
                {'name' => 'Shirt', 'room' => 'bedroom', 'available' => true}]
    compare(<<URL_WHERE, {'products' => products})
{% assign kitchen_products = products | where: "room", "kitchen" %}

Kitchen products:
{% for product in kitchen_products %}
- {{ product.name }}
{% endfor %}

{% assign available_products = products | where: "available" %}

Available products:
{% for product in available_products %}
- {{ product.name }}
{% endfor %}

First shirt:
- {{ products | where: "room", "bedroom" | first }}
URL_WHERE
  end
end
