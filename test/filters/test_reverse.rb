require_relative '../test_base'

class TestReverse < TestBase
  def test_reverse
    fire( <<REVERSE)
{% assign my_array = "apples, oranges, peaches, plums" | split: ", " %}

{{ my_array | reverse | join: ", " }}

{{ "Ground control to Major Tom." | split: "" | reverse | join: "" }}
REVERSE
  end
end
