require_relative '../test_base'

class TestMinus < TestBase
  def test_minus
    compare(<<MINUS)
{{ 4 | minus: 2 }}
{{ 16 | minus: 4 }}
{{ 183.357 | minus: 12 }}
MINUS
  end
end
