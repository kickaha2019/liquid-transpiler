require_relative '../test_base'

class TestAbs < TestBase
  def test_abs
    fire( <<ABS)
{{ -17 | abs }}
{{ 4 | abs }}
{{ "4" | abs }}
{{ "-19.86" | abs }}
ABS
  end
end
