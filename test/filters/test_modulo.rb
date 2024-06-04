require_relative '../test_base'

class TestModulo < TestBase
  def test_modulo
    fire( <<MODULO)
{{ 3 | modulo: 2 }}
{{ 24 | modulo: 7 }}
{{ 183.357 | modulo: 12 }}
MODULO
  end
end
