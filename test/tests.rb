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
    prepare( <<RENDER1, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER1
    fire2( "{% render 'included', count:3, fruit:'apples' %}",
           {})
  end

  def test_render3
    prepare( <<RENDER1, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER1
    fire2( "{% render 'included', count:counts[0],fruit:'apples' %}",
           {'counts' => [3]})
  end

  def test_split
    fire( <<SPLIT)
{% assign beatles = "John, Paul, George, Ringo" | split: ", " %}

{% for member in beatles %}
  {{ member }}
{% endfor %}
SPLIT
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
