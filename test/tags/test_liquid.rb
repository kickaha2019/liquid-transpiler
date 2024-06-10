require_relative '../test_base'

class TestLiquid < TestBase
  def test_liquid1
    compare(<<LIQUID1)
{% liquid
  # this is a comment
  assign topic = 'Learning about comments!'
  echo topic
%}
LIQUID1
  end

  def test_liquid2
    compare(<<LIQUID2)
{% liquid
case 2
when 1
  echo 'apple' | capitalize
when 2
  echo 'banana' | capitalize
when 3
  echo 'currant' | capitalize
endcase %}
LIQUID2
  end
end

