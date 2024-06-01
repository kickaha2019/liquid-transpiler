require_relative '../test_base'

class TestAtLeast < TestBase
  def test_at_least
    fire( <<AT_LEAST)
{{ 4 | at_least: 5 }}
{{ 4 | at_least: 3 }}
AT_LEAST
  end
end
