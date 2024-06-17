# frozen_string_literal: true

require_relative '../test_base'

class TestUrlEncode < TestBase
  def test_url_encode
    compare(<<~URL_ENCODE)
      {{ "john@liquid.com" | url_encode }}
      
      {{ "Tetsuro Takara" | url_encode }}
    URL_ENCODE
  end
end
