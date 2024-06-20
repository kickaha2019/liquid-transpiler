# frozen_string_literal: true

require_relative '../test_base'

class TestCase < TestBase
  def test_case
    compare(<<~CASE)
      {% case 2 %}
      {% when 1 %}Apple
      {% when 2 %}Banana
      {% endcase %}
    CASE
  end

  def test_case_else
    compare(<<~CASE_ELSE)
      {% case 2 %}
      {% when 1 %}Apple
      {% else %}Banana
      {% endcase %}
    CASE_ELSE
  end

  def test_case2
    expect_code(<<~CASE2, /def t0\(a0\)/)
      {% case 2 %}
      {% when 1 %}{% assign fruit = 'Apple' %}
      {% when 2 %}{% assign fruit = 'Banana' %}
      {% endcase %}
      {{ fruit }}
    CASE2
  end

  def test_case3
    expect_code(<<~CASE3, /def t0\(\)/)
      {% case 2 %}
      {% when 1 %}{% assign fruit = 'Apple' %}
      {% when 2 %}{% assign fruit = 'Banana' %}
      {% else %}{% assign fruit = 'Durian' %}
      {% endcase %}
      {{ fruit }}
    CASE3
  end
end
