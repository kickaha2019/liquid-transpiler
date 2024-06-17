# frozen_string_literal: true
require_relative '../test_base'

class TestComment < TestBase
  def test_comment1
    compare(<<~COMMENT)
      {% assign verb = "turned" %}
      {% comment %}
      {% assign verb = "converted" %}
      {% endcomment %}
      Anything you put between comment and endcomment tags
      is {{ verb }} into a comment.
    COMMENT
  end

  def test_comment2
    compare(<<~COMMENT)
      {% # for i in (1..3) -%}
        {{ i }}
      {% # endfor %}
    COMMENT
  end

  def test_comment3
    compare(<<~INLINE_COMMENT)
      {%
        ###############################
        # This is a comment
        # across multiple lines
        ###############################
      %}
    INLINE_COMMENT
  end
end

