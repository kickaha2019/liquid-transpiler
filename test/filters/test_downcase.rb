# frozen_string_literal: true
require_relative '../test_base'

class TestDowncase < TestBase
  def test_downcase1
    compare(<<~DOWNCASE)
      {{ "Parker Moore" | downcase }}
    DOWNCASE
  end

  def test_downcase2
    compare(<<~DOWNCASE)
      {{ 123 | downcase }}
    DOWNCASE
  end
end
