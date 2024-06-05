require_relative '../test_base'

class TestStrip < TestBase
  def test_strip
    compare(<<STRIP)
{{ "          So much room for activities          " | strip }}!
STRIP
  end
end
