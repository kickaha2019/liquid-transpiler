# frozen_string_literal: true

require_relative '../test_base'

class TestEscape < TestBase
  def test_escape1
    compare(<<~ESCAPE)
      {{ "Have you read 'James & the Giant Peach'?" | escape }}
    ESCAPE
  end

  def test_escape2
    compare(<<~ESCAPE)
      {{ 'Special characters " < >' | escape }}
    ESCAPE
  end

  def test_escape3
    compare(<<~ESCAPE)
      {{ 123 | escape }}
    ESCAPE
  end
end
