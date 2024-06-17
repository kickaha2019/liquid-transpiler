# frozen_string_literal: true
require_relative '../test_base'

class TestStripHtml < TestBase
  def test_strip_html
    compare(<<~STRIP_HTML)
      {{ "Have <em>you</em> read <strong>Ulysses</strong>?" | strip_html }}
    STRIP_HTML
  end
end
