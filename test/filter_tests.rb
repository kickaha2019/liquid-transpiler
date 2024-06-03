require_relative 'test_base'

class FilterTests < TestBase
  def test_lstrip
    fire( <<LSTRIP)
{{ "          So much room for activities          " | lstrip }}!
LSTRIP
  end

  def test_minus
    fire( <<MINUS)
{{ 4 | minus: 2 }}
{{ 16 | minus: 4 }}
{{ 183.357 | minus: 12 }}
MINUS
  end

  def test_modulo
    fire( <<MODULO)
{{ 3 | modulo: 2 }}
{{ 24 | modulo: 7 }}
{{ 183.357 | modulo: 12 }}
MODULO
  end

  def test_newline_to_br
    fire( <<NEWLINE_TO_BR)
{% capture string_with_newlines %}
Hello
there
{% endcapture %}

{{ string_with_newlines | newline_to_br }}
NEWLINE_TO_BR
  end

  def test_plus
    fire( <<PLUS)
{{ 4 | plus: 2 }}
{{ 16 | plus: 4 }}
{{ 183.357 | plus: 12 }}
PLUS
  end

  def test_prepend
    fire( <<PREPEND)
{{ "apples, oranges, and bananas" | prepend: "Some fruit: " }}
{% assign url = "example.com" %}
{{ "/index.html" | prepend: url }}
PREPEND
  end

  def test_remove
    fire( <<REMOVE)
{{ "I strained to see the train through the rain" | remove: "rain" }}
REMOVE
  end

  def test_remove_first
    fire( <<REMOVE_FIRST)
{{ "I strained to see the train through the rain" | remove_first: "rain" }}
REMOVE_FIRST
  end

  def test_replace
    fire( <<REPLACE)
{{ "Take my protein pills and put my helmet on" | replace: "my", "your" }}
REPLACE
  end

  def test_replace_first
    fire( <<REPLACE_FIRST)
{{ "Take my protein pills and put my helmet on" | replace_first: "my", "your" }}
REPLACE_FIRST
  end

  def test_reverse
    fire( <<REVERSE)
{% assign my_array = "apples, oranges, peaches, plums" | split: ", " %}

{{ my_array | reverse | join: ", " }}

{{ "Ground control to Major Tom." | split: "" | reverse | join: "" }}
REVERSE
  end

  def test_round
    fire( <<ROUND)
{{ 1.2 | round }}
{{ 2.7 | round }}
{{ 183.357 | round: 2 }}
ROUND
  end

  def test_rstrip
    fire( <<RSTRIP)
{{ "          So much room for activities          " | rstrip }}!
RSTRIP
  end

  def test_size
    fire( <<SIZE)
{{ "Ground control to Major Tom." | size }}
  
{% assign my_array = "apples, oranges, peaches, plums" | split: ", " %}

{{ my_array.size }} 

{% if my_array.size > 3 %}
  Plenty of fruit!
{% endif %}
SIZE
  end

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
