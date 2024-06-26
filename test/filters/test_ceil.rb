# frozen_string_literal: true

require_relative '../test_base'

class TestCeil < TestBase
  def test_ceil
    compare(<<~CEIL)
      {{ 1.2 | ceil }}
      {{ 2.0 | ceil }}
      {{ 183.357 | ceil }}
      {{ "3.5" | ceil }}
    CEIL
  end
end
