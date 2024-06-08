require_relative '../test_base'

class TestComment < TestBase
  def test_comment
    compare(<<COMMENT)
{% assign verb = "turned" %}
{% comment %}
{% assign verb = "converted" %}
{% endcomment %}
Anything you put between comment and endcomment tags
is {{ verb }} into a comment.
COMMENT
  end
end

