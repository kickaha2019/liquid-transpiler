require_relative '../test_base'

class TestReplaceFirst < TestBase
  def test_replace_first
    fire( <<REPLACE_FIRST)
{{ "Take my protein pills and put my helmet on" | replace_first: "my", "your" }}
REPLACE_FIRST
  end
end
