require_relative '../test_base'

class TestAtMost < TestBase
  def test_at_most
    fire( <<AT_MOST)
{{ 4 | at_most: 5 }}
{{ 4 | at_most: 3 }}
AT_MOST
  end
end
