require_relative '../test_base'

class TestDowncase < TestBase
  def test_downcase
    compare(<<DOWNCASE)
{{ "Parker Moore" | downcase }}
DOWNCASE
  end
end
