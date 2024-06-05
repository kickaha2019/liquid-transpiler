require_relative '../test_base'

class TestLstrip < TestBase
  def test_lstrip
    compare(<<LSTRIP)
{{ "          So much room for activities          " | lstrip }}!
LSTRIP
  end
end
