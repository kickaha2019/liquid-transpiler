require_relative '../test_base'

class TestPlus < TestBase
  def test_plus
    fire( <<PLUS)
{{ 4 | plus: 2 }}
{{ 16 | plus: 4 }}
{{ 183.357 | plus: 12 }}
PLUS
  end
end
