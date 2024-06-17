# frozen_string_literal: true
require_relative '../test_base'

class TestRaw < TestBase
  def test_raw
    compare(<<~RAW)
      {% raw %}
      In Handlebars, {{ this }} will be HTML-escaped, but {{{ that }}} will not.
      {% endraw %}
    RAW
  end
end

