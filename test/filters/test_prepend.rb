# frozen_string_literal: true

require_relative '../test_base'

class TestPrepend < TestBase
  def test_prepend
    compare(<<~PREPEND)
      {{ "apples, oranges, and bananas" | prepend: "Some fruit: " }}
      {% assign url = "example.com" %}
      {{ "/index.html" | prepend: url }}
      {{ 123 | prepend: 456 }}
    PREPEND
  end
end
