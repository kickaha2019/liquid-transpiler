require_relative '../test_base'

class TestRemoveFirst < TestBase
  def test_remove_first
    compare(<<REMOVE_FIRST)
{{ "I strained to see the train through the rain" | remove_first: "rain" }}
{{ 121 | remove_first: 1 }}
REMOVE_FIRST
  end
end
