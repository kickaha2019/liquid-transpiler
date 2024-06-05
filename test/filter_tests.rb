require_relative 'test_base'

class FilterTests < TestBase
  def test_times
    compare(<<TIMES)
{{ 3 | times: 2 }}    
{{ 24 | times: 7 }}    
{{ 183.357 | times: 12 }}
TIMES
  end

  def test_truncate
    compare(<<TRUNCATE)
{{ "Ground control to Major Tom." | truncate: 50 }}

{{ "Ground control to Major Tom." | truncate: 20 }}

{{ "Ground control to Major Tom." | truncate: 25, ", and so on" }}

{{ "Ground control to Major Tom." | truncate: 20, "" }}
TRUNCATE
  end

  def test_truncatewords
    compare(<<TRUNCATEWORDS)
{{ "Ground control to Major Tom." | truncatewords: 50 }}

{{ "Ground control to Major Tom." | truncatewords: 3 }}

{{ "Ground control to Major Tom." | truncatewords: 3, "---" }}

{{ "Ground control to Major Tom." | truncatewords: 3, "" }}
TRUNCATEWORDS
  end

  def test_uniq
    compare(<<UNIQ)
{% assign my_array = "ants, bugs, bees, bugs, ants" | split: ", " %}

{{ my_array | uniq | join: ", " }}
UNIQ
  end

  def test_upcase
    compare(<<UPCASE)
{{ "Parker Moore" | upcase }}
UPCASE
  end

  def test_url_decode
    compare(<<URL_DECODE)
{{ "%27Stop%21%27+said+Fred" | url_decode }}
URL_DECODE
  end

  def test_url_encode
    compare(<<URL_ENCODE)
{{ "john@liquid.com" | url_encode }}

{{ "Tetsuro Takara" | url_encode }}
URL_ENCODE
  end

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
