# frozen_string_literal: true

require_relative '../test_base'

class TestUnknown < TestBase
  def test_unknown
    code = <<~UNKNOWN
      {{ 123 | unknown: 456 }}
    UNKNOWN
    expect_runtime_exception(code) do |e|
      unless /Undefined filter: unknown/ =~ e.message
        raise 'Expected exception not raised'
      end
      unless e.backtrace[1] == 'test.liquid:1:1'
        raise 'Backtrace not modified'
      end
    end
  end
end
