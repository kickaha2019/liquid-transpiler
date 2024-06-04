require_relative '../test_base'

class TestRound < TestBase
  def test_round
    fire( <<ROUND)
{{ 1.2 | round }}
{{ 2.7 | round }}
{{ 183.357 | round: 2 }}
ROUND
  end
end
