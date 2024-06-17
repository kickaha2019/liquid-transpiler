# frozen_string_literal: true
require_relative '../test_base'

class TestPlus < TestBase
  def test_plus1
    compare(<<~PLUS)
      {{ 4 | plus: 2 }}
      {{ 16 | plus: 4 }}
      {{ 183.357 | plus: 12 }}
      {{ "183.357" | plus: "12" }}
    PLUS
  end

  def test_plus2
    compare(<<~PLUS2, {'left' => 4, 'right' => 2})
      {{ left | plus: right }}
    PLUS2
  end

  def test_plus3
    compare(<<~PLUS2, {'values' => [7, 11]})
      {{ values[0] | plus: values[1] }}
    PLUS2
  end
end
