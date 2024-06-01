require_relative '../test_base'

class TestCapitalize < TestBase
  def test_capitalize
    fire( <<CAPITALIZE)
{{ "my GREAT title" | capitalize }}
CAPITALIZE
  end
end
