#
# To run individual test add command line argument
# like:
#
#   --name=test_object
#

require 'minitest/autorun'
require 'liquid'

require_relative '../lib/transpiler'

class TestTranspiler < Minitest::Test
  @@transpiler  = Transpiler.new
  @@dir         = ENV['TEMP_DIR'] ? ENV['TEMP_DIR'] : Dir.tmpdir
  Liquid::Template.file_system = Liquid::LocalFileSystem.new( @@dir,
                                                              pattern = "%s.liquid")
  Liquid.cache_classes = false

  def setup
    Dir.entries( @@dir).each do |f|
      if /\.liquid$/ =~ f
        File.delete( @@dir + '/' + f)
      end
    end
  end

  def fire( code, params = {})
    liquid         =  Liquid::Template.parse(code)
    liquid_output  =  liquid.render( params)
    clazz          =  "Temp"
    @@transpiler.transpile_source( 'test', code, clazz, @@dir)
    load( @@dir + '/' + clazz + '.rb')
    transpiled_output = Object.const_get(clazz).test( params)
    assert_equal liquid_output, transpiled_output
  end

  def fire2( code, params = {})
    liquid         =  Liquid::Template.parse(code)
    liquid_output  =  liquid.render( params)
    prepare( code, 'test.liquid')
    clazz          =  "Temp"
    @@transpiler.transpile_dir( @@dir, clazz, @@dir)
    load( @@dir + '/' + clazz + '.rb')
    transpiled_output = Object.const_get(clazz).test( params)
    assert_equal liquid_output, transpiled_output
  end

  def prepare( code, path)
    File.open( @@dir + '/' + path, 'w') do |io|
      io.print code
    end
  end

  def test_abs
    fire( <<ABS)
{{ -17 | abs }}
{{ 4 | abs }}
{{ "-19.86" | abs }}
ABS
  end

  def test_and_or1
    fire( <<AND_OR1)
{% if true or false and false %}
  This evaluates to true, since the `and` condition is checked first.
{% endif %}
AND_OR1
  end

  def test_and_or2
    fire( <<AND_OR2)
{% if true and false and false or true %}
  This evaluates to false, since the tags are checked like this:

  true and (false and (false or true))
  true and (false and true)
  true and false
  false
{% endif %}
AND_OR2
  end

  def test_append
    fire( <<APPEND)
{{ "/my/fancy/url" | append: ".html" }}
{% assign filename = "/index.html" %}
{{ "website.com" | append: filename }}
APPEND
  end

  def test_assign1
    fire( <<ASSIGN1)
{% assign my_variable = "tomato" %}
{{ my_variable }}
ASSIGN1
  end

  def test_at_least
    fire( <<AT_LEAST)
{{ 4 | at_least: 5 }}
{{ 4 | at_least: 3 }}
AT_LEAST
  end

  def test_at_most
    fire( <<AT_MOST)
{{ 4 | at_most: 5 }}
{{ 4 | at_most: 3 }}
AT_MOST
  end

  def test_break
    fire( <<BREAK)
{% for i in (0..9) %}
{{ i }}
{% break %}
{% endfor %}
BREAK
  end

  def test_capitalize
    fire( <<CAPITALIZE)
{{ "my GREAT title" | capitalize }}
CAPITALIZE
  end

  def test_capture
    fire( <<CAPTURE)
{% assign favorite_food = "pizza" %}
{% assign age = 35 %}

{% capture about_me %}
I am {{ age }} and my favorite food is {{ favorite_food }}.
{% endcapture %}

{{ about_me }}
CAPTURE
  end

  def test_case
    fire( <<CASE)
{% case 2 %}
{% when 1 %}Apple
{% when 2 %}Banana
{% endcase %}
CASE
  end

  def test_case_else
    fire( <<CASE_ELSE)
{% case 2 %}
{% when 1 %}Apple
{% else %}Banana
{% endcase %}
CASE_ELSE
  end

  def test_ceil
    fire( <<CEIL)
{{ "my GREAT title" | capitalize }}
{{ 1.2 | ceil }}
{{ 2.0 | ceil }}
{{ 183.357 | ceil }}
{{ "3.5" | ceil }}
CEIL
  end

  def test_comment
    fire( <<COMMENT)
{% assign verb = "turned" %}
{% comment %}
{% assign verb = "converted" %}
{% endcomment %}
Anything you put between {% comment %} and {% endcomment %} tags
is {{ verb }} into a comment.
COMMENT
  end

  def test_compact
    fire( <<COMPACT, {'items' => [{'category' => 'A'},{},{'category' => 'B'}]})
{% assign categories = items | map: "category" | compact %}

{% for category in categories %}
- {{ category }}
{% endfor %}
COMPACT
  end

  def test_concat
    fire( <<CONCAT)
{% assign fruits = "apples, oranges, peaches" | split: ", " %}
{% assign vegetables = "carrots, turnips, potatoes" | split: ", " %}

{% assign everything = fruits | concat: vegetables %}

{% for item in everything %}
- {{ item }}
{% endfor %}
CONCAT
  end

  def test_contains1
    fire( <<CONTAINS1)
{% assign title = "Gage Blackwood" %}
{% if title contains "Gage" %}
  Agent 5
{% endif %}
CONTAINS1
  end

  def test_contains2
    fire( <<CONTAINS2)
{% assign names = "Gage Blackwood" | split: ' ' %}
{% if names contains "Gage" %}
  Agent 5
{% endif %}
CONTAINS2
  end

  def test_continue
    fire( <<CONTINUE)
{% for i in (1..5) %}
  {% if i == 4 %}
    {% continue %}
  {% else %}
    {{ i }}
  {% endif %}
{% endfor %}
CONTINUE
  end

  def test_cycle
    fire( <<CYCLE, {'basket' => ['Apple','Banana']})
{% for fruit in basket %}
  {% cycle "one", "two", "three" %}
  {% cycle "special": "one", "two", "three" %}
{% endfor %}
CYCLE
  end

  def test_date
    fire( <<DATE1, {'published_at' => Time.gm(2024,5,20)})
{{ published_at | date: "%a, %b %d, %y" }}
DATE1
    fire( <<DATE2)
{{ "March 14, 2016" | date: "%b %d, %y" }}
DATE2
    fire( <<DATE3)
now {{ "now" | date: "%Y-%m-%d" }}
today {{ "today" | date: "%Y-%m-%d" }}
DATE3
  end

  def test_decrement
    fire( <<DECREMENT)
{% assign var = 10 %}
{% decrement var %}
{% decrement var %}
{% decrement var %}
{{ var }}
DECREMENT
  end

  def test_default
    fire( <<DEFAULT)
{{ field1 | default: 2.99 }}
{% assign field2 = 4.99 %}
{{ field2 | default: 2.99 }}
{% assign field3 = "" %}
{{ field3 | default: 2.99 }}
{% assign field4 = false %}
{{ field4 | default: true, allow_false: true }}
DEFAULT
  end

  def test_downcase
    fire( <<DOWNCASE)
{{ "Parker Moore" | downcase }}
DOWNCASE
  end

  def test_divided_by
    fire( <<DIVIDED_BY)
{{ 16 | divided_by: 4 }}
{{ 5 | divided_by: 3 }}
{{ 20 | divided_by: 7.0 }}
DIVIDED_BY
  end

  def test_empty
    fire( <<EMPTY, {'array' => []})
{% if "" == empty %}
Empty string
{% endif %}
{% if array == empty %}
Empty array
{% endif %}
{% if unknown %}
Non-existing object
{% endif %}
EMPTY
  end

  def test_escape
    fire( <<ESCAPE)
{{ "Have you read 'James & the Giant Peach'?" | escape }}
ESCAPE
  end

  def test_escape_once
    fire( <<ESCAPE_ONCE)
{{ "1 < 2 & 3" | escape_once | escape_once }}
ESCAPE_ONCE
  end

  def test_first
    fire( <<FIRST)
{{ "Ground control to Major Tom." | split: " " | first }}

{% assign my_array = "zebra, octopus, giraffe, tiger" | split: ", " %}
{% if my_array.first == "zebra" %}
  Here comes a zebra!
{% endif %}
FIRST
  end

  def test_floor
    fire( <<FLOOR)
{{ 1.2 | floor }}
{{ 2.0 | floor }}
{{ 183.357 | floor }}
{{ "3.5" | floor }}
FLOOR
  end

  def test_for
    fire( <<FOR, {'basket' => ['Apple']})
{% for fruit in basket %}
{{ fruit }}
{% endfor %}
FOR
  end

  def test_for_else
    fire( <<FOR, {'basket' => []})
{% for fruit in basket %}
{{ fruit }}
{% else %}
Empty basket
{% endfor %}
FOR
  end

  def test_for_limit
    fire( <<FOR_LIMIT, {'array' => [1,2,3,4,5,6]})
{% for item in array reversed limit:2 %}
  {{ item }}
{% endfor %}
FOR_LIMIT
  end

  def test_for_offset1
    fire( <<FOR_OFFSET1, {'array' => [1,2,3,4,5,6]})
{% for item in array offset:2 %}
  {{ item }}
{% endfor %}
FOR_OFFSET1
  end

  def test_for_offset2
    fire( <<FOR_OFFSET2, {'array' => [1,2,3,4,5,6]})
{% for item in array limit:3 %}
  {{ item }}
{% endfor %}
{% for item in array limit: 3 offset: continue %}
  {{ item }}
{% endfor %}
FOR_OFFSET2
  end

  def test_for_range
    fire( <<FOR_RANGE, {'array' => [1,2,3,4,5,6]})
{% for i in (3..5) %}
  {{ i }}
{% endfor %}

{% assign num = 4 %}
{% assign range = (1..num) %}
{% for i in range %}
  {{ i }}
{% endfor %}
FOR_RANGE
  end

  def test_forloop
    fire( <<FORLOOP, {'array1' => [1], 'array2' => [1,2]})
{% for item1 in array1 %}
  {% for item2 in array2 %}
    parent length {{ forloop.parentloop.length }}
    length {{ forloop.length }}
    index {{ forloop.index }}
    index0 {{ forloop.index0 }}
    rindex {{ forloop.rindex }}
    rindex0 {{ forloop.rindex0 }}
    first {{ forloop.first }}
    last {{ forloop.last }}
  {% endfor %}
{% endfor %}
FORLOOP
  end

  def test_if_else
    fire( <<IF_ELSE)
{% if false %}
Apple
{% else %}
Banana
{% endif %}
IF_ELSE
  end

  def test_if1
    fire( <<IF1, {'fruit' => {'green' => true, 'red' => false}})
{% if fruit.green or fruit.red %}
Apple
{% endif %}
IF1
  end

  def test_if2
    fire( <<IF2)
{% if true %}
Apple
{% endif %}
IF2
  end

  def test_increment
    fire( <<INCREMENT)
{% assign var = 10 %}
{% increment var %}
{% increment var %}
{% increment var %}
{{ var }}
INCREMENT
  end

  def test_inline_comment
    fire( <<INLINE_COMMENT)
{% # for i in (1..3) -%}
  {{ i }}
{% # endfor %}

{%
  ###############################
  # This is a comment
  # across multiple lines
  ###############################
%}
INLINE_COMMENT
  end

  def test_join
    fire( <<JOIN)
{% assign beatles = "John, Paul, George, Ringo" | split: ", " %}

{{ beatles | join: " and " }}
JOIN
  end

  def test_last
    fire( <<LAST)
{{ "Ground control to Major Tom." | split: " " | last }}

{% assign my_array = "zebra, octopus, giraffe, tiger" | split: ", " %}
{{ my_array.last }}

{% if my_array.last == "tiger" %}
  There goes a tiger!
{% endif %}
LAST
  end

  def test_liquid1
    fire( <<LIQUID1)
{% liquid
  # this is a comment
  assign topic = 'Learning about comments!'
  echo topic
%}
LIQUID1
  end

  def test_liquid2
    fire( <<LIQUID2)
{% liquid
case 2
when 1
  echo 'apple' | capitalize
when 2
  echo 'banana' | capitalize
when 3
  echo 'currant' | capitalize
endcase %}
LIQUID2
  end

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

  def test_nil
    fire( <<NIL, {'hash' => {}})
{% if hash.missing %}
Wasn't nil
{% else %}
Was nil
{% endif %}    
{{ hash.nothing }}
NIL
  end

  def test_object1
    fire( '{{ hash.array[0] }}', {'hash' => {'array' => ['Hello World']}})
  end

  def test_object2
    fire( '{{ hash.array[0].field }}',
          {'hash' => {'array' => [{'field' => 'Hello World'}]}})
  end

  def test_object3
    fire( %Q({{ "{{ }} {% %} \\"" }}))
  end

  def test_object4
    fire( %Q({{ '{{ }} {% %} \\'' }}))
  end

  def test_operators
    fire( <<OPERATORS)
{% false or 1 == 1 %}
Correct 1
{% endif %}
{% 1 != 2 and true %}
Correct 2
{% endif %}
{% false or 1 > -1 %}
Correct 3
{% endif %}
{% 1 < 2 and true %}
Correct 4
{% endif %}
{% false or 1 >= -1 %}
Correct 5
{% endif %}
{% 1 <= 2 and true %}
Correct 6
{% endif %}
OPERATORS
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

  def test_raw
    fire( <<RAW)
{% raw %}
In Handlebars, {{ this }} will be HTML-escaped, but {{{ that }}} will not.
{% endraw %}
RAW
  end

  def test_remove
    fire( <<REMOVE)
{{ "I strained to see the train through the rain" | replace: "rain" }}
REMOVE
  end

  def test_remove_first
    fire( <<REMOVE_FIRST)
{{ "I strained to see the train through the rain" | remove_first: "rain" }}
REMOVE_FIRST
  end

  def test_render1
    prepare( <<RENDER1, 'included.liquid')
Passed {{ threepwood }}
RENDER1
    fire2( "{% render 'included', threepwood:guybrush %}",
           {'guybrush' => 'Mighty pirate'})
  end

  def test_render2
    prepare( <<RENDER2, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER2
    fire2( "{% render 'included', count:3, fruit:'apples' %}",
           {})
  end

  def test_render3
    prepare( <<RENDER3, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER3
    fire2( "{% render 'included', count:counts[0],fruit:'apples' %}",
           {'counts' => [3]})
  end

  def test_render4
    prepare( <<RENDER4, 'included.liquid')
Passed {{ threepwood }}
RENDER4
    fire2( "{% render 'included' with guybrush as threepwood %}",
           {'guybrush' => 'Mighty pirate'})
  end

  def test_render5
    prepare( <<RENDER5, 'included.liquid')
Passed {{ name }}
length {{ forloop.length }}
index {{ forloop.index }}
index0 {{ forloop.index0 }}
rindex {{ forloop.rindex }}
rindex0 {{ forloop.rindex0 }}
first {{ forloop.first }}
last {{ forloop.last }}
RENDER5
    fire2( "{% render 'included' for names as name %}",
           {'names' => ['Guybrush','Threepwood']})
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

  def test_tablerow
    fire( <<TABLEROW, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit %}
  {{ item }}
{% endtablerow %}
TABLEROW
  end

  def test_tablerow_cols
    fire( <<TABLEROW_COLS, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit cols:1 %}
  {{ item }}
{% endtablerow %}
TABLEROW_COLS
  end

  def test_tablerow_limit
    fire( <<TABLEROW_LIMIT, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit cols:1 limit:1 %}
  {{ item }}
{% endtablerow %}
TABLEROW_LIMIT
  end

  def test_tablerow_offset
    fire( <<TABLEROW_OFFSET, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit cols:1 offset:1 %}
  {{ item }}
{% endtablerow %}
TABLEROW_OFFSET
  end

  def test_tablerow_range
    fire( <<TABLEROW_RANGE)
{% tablerow item in (3..5) %}
  {{ item }}
{% endtablerow %}
TABLEROW_RANGE
  end

  def test_tablerowloop
    fire( <<TABLEROWLOOP)
{% tablerow item in (3..5) cols:2 %}
  col {{ tablerowloop.col }}
  col0 {{ tablerowloop.col0 }}
  col_first {{ tablerowloop.col_first }}
  col_last {{ tablerowloop.col_last }}
  first {{ tablerowloop.first }}
  index {{ tablerowloop.index }}
  index0 {{ tablerowloop.index0 }}
  last {{ tablerowloop.last }}
  length {{ tablerowloop.length }}
  rindex {{ tablerowloop.rindex }}
  rindex0 {{ tablerowloop.rindex0 }}
  row {{ tablerowloop.row }}
{% endtablerow %}
TABLEROWLOOP
  end

  def test_text1
    fire( 'Hello World')
  end

  def test_text2
    fire( 'const re = /(?:\?|,)origin=([^#&]*)/;')
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

  def test_unless
    fire( <<UNLESS)
{% unless false %}
Apple
{% endunless %}
UNLESS
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

  def test_white_space
    fire( <<WHITE_SPACE)
{% assign username = "John G. Chalmers-Smith" %}
{%- if username and username.size > 10 -%}
  Wow, {{ username -}} , you have a long name!
{%- else -%}
  Hello there!
{%- endif %}
WHITE_SPACE
  end
end
