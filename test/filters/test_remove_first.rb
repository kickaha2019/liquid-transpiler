require_relative '../test_base'

class TestRemoveFirst < TestBase
  def test_remove_first
    fire( <<REMOVE_FIRST)
{{ "I strained to see the train through the rain" | remove_first: "rain" }}
REMOVE_FIRST
  end
end
