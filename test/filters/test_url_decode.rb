# frozen_string_literal: true

require_relative '../test_base'

class TestUrlDecode < TestBase
  def test_url_decode
    compare(<<~URL_DECODE)
      {{ "%27Stop%21%27+said+Fred" | url_decode }}
    URL_DECODE
  end
end
