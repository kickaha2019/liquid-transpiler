require_relative '../test_base'

class TestNewlineToBr < TestBase
  def test_newline_to_br
    compare(<<NEWLINE_TO_BR)
{% capture string_with_newlines %}
Hello
there
{% endcapture %}

{{ string_with_newlines | newline_to_br }}
NEWLINE_TO_BR
  end
end
