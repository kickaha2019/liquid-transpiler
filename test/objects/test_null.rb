# frozen_string_literal: true

require_relative '../test_base'

class TestNull < TestBase
  def test_null1
    compare(<<~NULL1)
      {% unless nothing %}
      Nothing passed
      {% endunless %}
    NULL1
  end
end
