# frozen_string_literal: true

require_relative '../test_base'

class TestUnknown < TestBase
  def test_unknown
    expect_runtime_exception(<<~UNKNOWN, /Undefined filter: unknown/)
      {{ 123 | unknown: 456 }}
    UNKNOWN
  end
end
