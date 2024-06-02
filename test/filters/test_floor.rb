require_relative '../test_base'

class TestFloor < TestBase
  def test_floor
    fire( <<FLOOR)
{{ 1.2 | floor }}
{{ 2.0 | floor }}
{{ 183.357 | floor }}
{{ "3.5" | floor }}
FLOOR
  end
end
