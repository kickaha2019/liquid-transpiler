# frozen_string_literal: true
require_relative '../test_base'

class TestStripNewlines < TestBase
  def test_strip_newlines
    compare(<<~STRIP_NEWLINES)
      {% capture string_with_newlines %}
      Hello
      there
      {% endcapture %}
      
      {{ string_with_newlines | strip_newlines }}
    STRIP_NEWLINES
  end
end
