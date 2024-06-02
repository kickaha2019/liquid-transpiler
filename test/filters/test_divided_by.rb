require_relative '../test_base'

class TestDividedBy < TestBase
  def test_divided_by
    fire( <<DIVIDED_BY)
{{ 16 | divided_by: 4 }}
{{ 5 | divided_by: 3 }}
{{ 20 | divided_by: 7.0 }}
DIVIDED_BY
  end
end
