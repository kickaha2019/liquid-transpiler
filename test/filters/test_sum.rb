# frozen_string_literal: true

require_relative '../test_base'

class TestSum < TestBase
  def test_sum1
    expect(<<~SUM1, {'animals' => [{'count' => 1}, {'count' => 3}]}, '4')
      {% assign total_count = animals | sum: "count" %}
      
      {{ total_count }}
    SUM1
  end

  def test_sum2
    expect(<<~SUM2, {'ratings' => [4, 8]}, '12')
      {{ ratings | sum }}
    SUM2
  end

  def test_sum3
    expect(<<~SUM3, {}, '21')
      {{ (1..6) | sum }}
    SUM3
  end
end
