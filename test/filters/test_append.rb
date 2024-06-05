require_relative '../test_base'

class TestAppend < TestBase
  def test_append
    compare(<<APPEND)
{{ "/my/fancy/url" | append: ".html" }}
{% assign filename = "/index.html" %}
{{ "website.com" | append: filename }}
APPEND
  end
end
