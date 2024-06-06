require_relative '../test_base'

class TestUpcase < TestBase
  def test_upcase
    compare(<<UPCASE)
{{ "Parker Moore" | upcase }}
UPCASE
  end
end
