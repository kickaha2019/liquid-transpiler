require_relative '../test_base'

class TestEscape < TestBase
  def test_escape_once
    fire( <<ESCAPE_ONCE)
{{ "1 < 2 & 3" | escape_once | escape_once }}
ESCAPE_ONCE
  end
end
