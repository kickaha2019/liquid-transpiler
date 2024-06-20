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

  def test_unless4
    expect_code(<<~UNLESS4, /def t0\(a0\)/)
      {% unless true %}
      {% assign fruit = 'Apple' %}
      {% endunless %}
      {{ fruit }}
    UNLESS4
  end

  def test_unless5
    expect_code(<<~UNLESS5, /def t0\(\)/)
      {% unless true %}
      {% assign fruit = 'Apple' %}
      {% else %}
      {% assign fruit = 'Banana' %}
      {% endunless %}
      {{ fruit }}
    UNLESS5
  end
end
