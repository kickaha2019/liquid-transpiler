# frozen_string_literal: true

require_relative '../test_base'

class TestAssign < TestBase
  def test_assign1
    compare(<<~ASSIGN1)
      {% assign my_variable = "tomato" %}
      {{ my_variable }}
    ASSIGN1
  end

  def test_assign2
    compare(<<~ASSIGN2)
      {% assign x-y-z = 12 %}

      {{ x-y-z }}
    ASSIGN2
  end

  def test_assign3
    compare(<<~ASSIGN2)
      {% assign -1a = 12 %}

      {{ -1a }}
    ASSIGN2
  end

  def test_assign4
    compare(<<~ASSIGN2)
      {% assign 0a = 12 %}

      {{ 0a }}
    ASSIGN2
  end

  def test_assign5
    compare(<<~ASSIGN2)
      {% assign -_ = 12 %}

      {{ -_ }}
    ASSIGN2
  end

  def test_assign6
    expect_code(<<~ASSIGN1, /def t0\(\)/)
      {% assign my_variable = "tomato" %}
      {{ my_variable }}
    ASSIGN1
  end

  def test_assign7
    expect_code(<<~ASSIGN7, /def t0\(a0\)/)
      {{ my_variable }}
      {% assign my_variable = "tomato" %}
      {{ my_variable }}
    ASSIGN7
  end
end
