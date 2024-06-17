# frozen_string_literal: true
require_relative '../test_base'

class TestTruncate < TestBase
  def test_truncate1
    compare(<<~TRUNCATE)
      {{ "Ground control to Major Tom." | truncate: 50 }}
    TRUNCATE
  end

  def test_truncate2
    compare(<<~TRUNCATE)
      {{ "Ground control to Major Tom." | truncate: 20 }}
    TRUNCATE
  end

  def test_truncate3
    compare(<<~TRUNCATE)
      {{ "Ground control to Major Tom." | truncate: 25, ", and so on" }}
    TRUNCATE
  end

  def test_truncate4
    compare(<<~TRUNCATE)
      {{ "Ground control to Major Tom." | truncate: 20, "" }}
    TRUNCATE
  end
end
