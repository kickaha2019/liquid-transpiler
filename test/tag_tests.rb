require_relative 'test_base'

class TagTests < TestBase
  def test_assign1
    fire( <<ASSIGN1)
{% assign my_variable = "tomato" %}
{{ my_variable }}
ASSIGN1
  end

  def test_break
    fire( <<BREAK)
{% for i in (0..9) %}
{{ i }}
{% break %}
{% endfor %}
BREAK
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

  def test_decrement
    fire( <<DECREMENT)
{% assign var = 10 %}
{% decrement var %}
{% decrement var %}
{% decrement var %}
{{ var }}
DECREMENT
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

  def test_object5
    fire( '{{ "Hello World" }}')
  end

  def test_raw
    fire( <<RAW)
{% raw %}
In Handlebars, {{ this }} will be HTML-escaped, but {{{ that }}} will not.
{% endraw %}
RAW
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

  def test_unless
    fire( <<UNLESS)
{% unless false %}
Apple
{% endunless %}
UNLESS
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