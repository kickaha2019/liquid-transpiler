# frozen_string_literal: true

require_relative '../test_base'

class TestAppend < TestBase
  def test_append1
    compare(<<~APPEND)
      {{ "/my/fancy/url" | append: ".html" }}
      {% assign filename = "/index.html" %}
      {{ "website.com" | append: filename }}
    APPEND
  end

  def test_append2
    compare(<<~APPEND)
      {{ 123 | append: 456 }}
    APPEND
  end
end
