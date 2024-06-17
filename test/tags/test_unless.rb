# frozen_string_literal: true

require_relative '../test_base'

class TestUnless < TestBase
  def test_unless
    compare(<<~UNLESS)
      {% unless false %}
      Apple
      {% endunless %}
    UNLESS
  end

  def test_unless_else
    compare(<<~IF_ELSE)
      {% unless true %}
      Apple
      {% else %}
      Banana
      {% endunless %}
    IF_ELSE
  end
end
