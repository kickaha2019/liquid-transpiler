# frozen_string_literal: true

require_relative '../test_base'

class TestWhere < TestBase
  def test_where1
    compare(<<~URL_WHERE, {'products' => poro_products})
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

  def test_where2
    compare(<<~URL_WHERE2, {'products' => nil})
      {% assign kitchen_products = products | where: "type", "kitchen" %}
      {% if kitchen_products %}
      Empty list
      {% else %}
      Null
      {% endif %}
    URL_WHERE2
  end
end
