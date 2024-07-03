# frozen_string_literal: true

require_relative '../test_base'

class TestString < TestBase
  def test_string1
    compare('{{ "Hello World" }}')
  end

  def test_string2
    compare('{{ "\n" }}')
  end

  def test_string3
    compare(%q({{ '\n' }}))
  end

  def test_string4
    compare(<<~STRING4)
      {{ ' A two-line
      string '}}
    STRING4
  end
end
