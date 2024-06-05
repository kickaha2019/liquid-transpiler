require_relative 'test_base'

class FilterTests < TestBase
  def test_slice
    fire( <<SLICE)
{{ "Liquid" | slice: 0 }}
{{ "Liquid" | slice: 2 }}
{{ "Liquid" | slice: 2, 5 }}
{{ "Liquid" | slice: -3, 2 }}
{% assign beatles = "John, Paul, George, Ringo" | split: ", " %}
{{ beatles | slice: 0 }}
{{ beatles | slice: 1, 2 }}
{{ beatles | slice: -2 2 }}
SLICE
  end

  def test_sort1
    fire( <<SORT1)
{% assign my_array = "zebra, octopus, giraffe, Sally Snake" | split: ", " %}

{{ my_array | sort | join: ", " }}
SORT1
  end

  def test_sort2
    fire( <<SORT2, {'fruit' => [{'price' => 3, 'name' => 'Apple'},{'price' => 2, 'name' => 'Banana'}]})
{% assign fruit_by_price = fruit | sort: "price" %}
{% for item in fruit_by_price %}
  <h4>{{ item.name }}</h4>
{% endfor %}
SORT2
  end

  def test_sort_natural1
    fire( <<SORT1)
{% assign my_array = "zebra, octopus, giraffe, Sally Snake" | split: ", " %}

{{ my_array | sort_natural | join: ", " }}
SORT1
  end

  def test_sort_natural2
    fire( <<SORT2, {'animals' => [{'name' => 'zebra'},{'name' => 'Sally Snake'}]})
{% assign animals_by_name = animals | sort: "name" %}
{% for animal in animals_by_name %}
  <h4>{{ animal.name }}</h4>
{% endfor %}
SORT2
  end

  def test_split
    fire( <<SPLIT)
{% assign beatles = "John, Paul, George, Ringo" | split: ", " %}

{% for member in beatles %}
  {{ member }}
{% endfor %}
SPLIT
  end

  def test_strip
    fire( <<STRIP)
{{ "          So much room for activities          " | strip }}!
STRIP
  end

  def test_strip_html
    fire( <<STRIP_HTML)
{{ "Have <em>you</em> read <strong>Ulysses</strong>?" | strip_html }}
STRIP_HTML
  end

  def test_strip_newlines
    fire( <<STRIP_NEWLINES)
{% capture string_with_newlines %}
Hello
there
{% endcapture %}

{{ string_with_newlines | strip_newlines }}
STRIP_NEWLINES
  end

  def test_sum1
    fire( <<SUM1, {'animals' => [{'count' => 1},{'count' => 3}]})
{% assign total_count = animals | sum: "count" %}

{{ total_count }}
SUM1
  end

  def test_sum2
    fire( <<SUM2, {'ratings' => [4,8]})
{{ ratings | sum }}
SUM2
  end

  def test_times
    fire( <<TIMES)
{{ 3 | times: 2 }}    
{{ 24 | times: 7 }}    
{{ 183.357 | times: 12 }}
TIMES
  end

  def test_truncate
    fire( <<TRUNCATE)
{{ "Ground control to Major Tom." | truncate: 50 }}

{{ "Ground control to Major Tom." | truncate: 20 }}

{{ "Ground control to Major Tom." | truncate: 25, ", and so on" }}

{{ "Ground control to Major Tom." | truncate: 20, "" }}
TRUNCATE
  end

  def test_truncatewords
    fire( <<TRUNCATEWORDS)
{{ "Ground control to Major Tom." | truncatewords: 50 }}

{{ "Ground control to Major Tom." | truncatewords: 3 }}

{{ "Ground control to Major Tom." | truncatewords: 3, "---" }}

{{ "Ground control to Major Tom." | truncatewords: 3, "" }}
TRUNCATEWORDS
  end

  def test_uniq
    fire( <<UNIQ)
{% assign my_array = "ants, bugs, bees, bugs, ants" | split: ", " %}

{{ my_array | uniq | join: ", " }}
UNIQ
  end

  def test_upcase
    fire( <<UPCASE)
{{ "Parker Moore" | upcase }}
UPCASE
  end

  def test_url_decode
    fire( <<URL_DECODE)
{{ "%27Stop%21%27+said+Fred" | url_decode }}
URL_DECODE
  end

  def test_url_encode
    fire( <<URL_ENCODE)
{{ "john@liquid.com" | url_encode }}

{{ "Tetsuro Takara" | url_encode }}
URL_ENCODE
  end

  def test_where
    products = [{'name' => 'Vacuum', 'room' => 'lounge', 'available' => true},
                {'name' => 'Spatula', 'room' => 'kitchen', 'available' => false},
                {'name' => 'Shirt', 'room' => 'bedroom', 'available' => true}]
    fire( <<URL_WHERE, {'products' => products})
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
