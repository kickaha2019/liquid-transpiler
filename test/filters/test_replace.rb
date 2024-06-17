# frozen_string_literal: true

require_relative '../test_base'

class TestReplace < TestBase
  def test_replace
    compare(<<~REPLACE)
      {{ "Take my protein pills and put my helmet on" | replace: "my", "your" }}
    REPLACE
  end
end
