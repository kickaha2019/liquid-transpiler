# frozen_string_literal: true

require_relative '../test_base'

class TestRstrip < TestBase
  def test_rstrip
    compare(<<~RSTRIP)
      {{ "          So much room for activities          " | rstrip }}!
      {{ 123 | rstrip }}
    RSTRIP
  end
end
