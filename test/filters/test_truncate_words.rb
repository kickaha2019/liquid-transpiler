# frozen_string_literal: true
require_relative '../test_base'

class TestTruncateWords < TestBase
  def test_truncatewords
    compare(<<~TRUNCATEWORDS)
      {{ "Ground control to Major Tom." | truncatewords: 50 }}
      
      {{ "Ground control to Major Tom." | truncatewords: 3 }}
      
      {{ "Ground control to Major Tom." | truncatewords: 3, "---" }}
      
      {{ "Ground control to Major Tom." | truncatewords: 3, "" }}
    TRUNCATEWORDS
  end
end
