# frozen_string_literal: true

require_relative '../test_base'

class TestTimes < TestBase
  def test_times
    compare(<<~TIMES)
      {{ 3 | times: 2 }}#{'    '}
      {{ 24 | times: 7 }}#{'    '}
      {{ 183.357 | times: 12 }}
      {{ "183.357" | times: "12" }}
    TIMES
  end
end
