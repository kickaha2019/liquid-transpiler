require_relative '../test_base'

class TestEscape < TestBase
  def test_escape
    fire( <<ESCAPE)
{{ "Have you read 'James & the Giant Peach'?" | escape }}
ESCAPE
    fire( <<ESCAPE)
{{ 'Special characters " < >' | escape }}
ESCAPE
  end
end
