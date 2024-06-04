require_relative '../test_base'

class TestRemove < TestBase
  def test_remove
    fire( <<REMOVE)
{{ "I strained to see the train through the rain" | remove: "rain" }}
REMOVE
  end
end
