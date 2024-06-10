require_relative 'test_base'

class TagTests < TestBase
  def test_tablerow
    compare(<<TABLEROW, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit %}
  {{ item }}
{% endtablerow %}
TABLEROW
  end

  def test_tablerow_cols
    compare(<<TABLEROW_COLS, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit cols:1 %}
  {{ item }}
{% endtablerow %}
TABLEROW_COLS
  end

  def test_tablerow_limit
    compare(<<TABLEROW_LIMIT, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit cols:1 limit:1 %}
  {{ item }}
{% endtablerow %}
TABLEROW_LIMIT
  end

  def test_tablerow_offset
    compare(<<TABLEROW_OFFSET, {'fruit' => ['Apple', 'Banana']})
{% tablerow item in fruit cols:1 offset:1 %}
  {{ item }}
{% endtablerow %}
TABLEROW_OFFSET
  end

  def test_tablerow_range
    compare(<<TABLEROW_RANGE)
{% tablerow item in (3..5) %}
  {{ item }}
{% endtablerow %}
TABLEROW_RANGE
  end

  def test_tablerowloop
    compare(<<TABLEROWLOOP)
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
    compare('Hello World')
  end

  def test_text2
    compare('const re = /(?:\?|,)origin=([^#&]*)/;')
  end

  def test_unless
    compare(<<UNLESS)
{% unless false %}
Apple
{% endunless %}
UNLESS
  end

  def test_white_space
    compare(<<WHITE_SPACE)
{% assign username = "John G. Chalmers-Smith" %}
{%- if username and username.size > 10 -%}
  Wow, {{ username -}} , you have a long name!
{%- else -%}
  Hello there!
{%- endif %}
WHITE_SPACE
  end
end
