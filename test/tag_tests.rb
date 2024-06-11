require_relative 'test_base'

class TagTests < TestBase
  def test_unless
    compare(<<UNLESS)
{% unless false %}
Apple
{% endunless %}
UNLESS
  end
end
