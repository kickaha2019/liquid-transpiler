require_relative '../test_base'

class TestLstrip < TestBase
  def test_lstrip1
    compare(<<LSTRIP)
{{ "          So much room for activities          " | lstrip }}!
LSTRIP
  end

  def test_lstrip2
    compare(<<LSTRIP)
{{ 123 | lstrip }}
LSTRIP
  end
end
