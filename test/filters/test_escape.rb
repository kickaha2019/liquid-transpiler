# frozen_string_literal: true
require_relative '../test_base'

class TestEscape < TestBase
  def test_escape
    compare(<<~ESCAPE)
      {{ "Have you read 'James & the Giant Peach'?" | escape }}
    ESCAPE
    compare(<<~ESCAPE)
      {{ 'Special characters " < >' | escape }}
    ESCAPE
    compare(<<~ESCAPE)
      {{ 123 | escape }}
    ESCAPE
  end
end
