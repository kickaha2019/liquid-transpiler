require_relative '../test_base'

class TestCapitalize < TestBase
  def test_capitalize1
    compare(<<CAPITALIZE)
{{ "my GREAT title" | capitalize }}
CAPITALIZE
  end

  def test_capitalize2
    compare(<<CAPITALIZE)
{{ 123 | capitalize }}
CAPITALIZE
  end
end
