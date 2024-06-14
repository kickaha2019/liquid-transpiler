require_relative '../test_base'

class TestIf < TestBase
  def test_if_else
    compare(<<IF_ELSE)
{% if false %}
Apple
{% else %}
Banana
{% endif %}
IF_ELSE
  end

  def test_if1
    compare(<<IF1, {'fruit' => {'green' => true, 'red' => false}})
{% if fruit.green or fruit.red %}
Apple
{% endif %}
IF1
  end

  def test_if2
    compare(<<IF2)
{% if true %}
Apple
{% endif %}
IF2
  end

  def test_if3
    expect_error( <<IF3, {}, /Unexpected tag endunless/)
{% if true %}
Bad syntax
{% endunless %}
IF3
  end
end

