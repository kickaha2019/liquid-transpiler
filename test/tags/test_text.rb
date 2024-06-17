# frozen_string_literal: true

require_relative '../test_base'

class TestText < TestBase
  def test_text1
    compare('Hello World')
  end

  def test_text2
    compare('const re = /(?:\?|,)origin=([^#&]*)/;')
  end

  def test_white_space
    compare(<<~WHITE_SPACE)
      {% assign username = "John G. Chalmers-Smith" %}
      {%- if username and username.size > 10 -%}
        Wow, {{ username -}} , you have a long name!
      {%- else -%}
        Hello there!
      {%- endif %}
    WHITE_SPACE
  end
end
