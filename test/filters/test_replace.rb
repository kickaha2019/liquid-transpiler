require_relative '../test_base'

class TestReplace < TestBase
  def test_replace
    fire( <<REPLACE)
{{ "Take my protein pills and put my helmet on" | replace: "my", "your" }}
REPLACE
  end
end
