# frozen_string_literal: true

require_relative '../test_base'

class TestModulo < TestBase
  def test_modulo
    compare(<<~MODULO)
      {{ 3 | modulo: 2 }}
      {{ 24 | modulo: 7 }}
      {{ 183.357 | modulo: 12 | round: 3 }}
      {{ "183.357" | modulo: "12" | round: 3 }}
    MODULO
  end
end
