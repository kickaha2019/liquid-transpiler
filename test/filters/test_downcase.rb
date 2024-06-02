require_relative '../test_base'

class TestDowncase < TestBase
  def test_downcase
    fire( <<DOWNCASE)
{{ "Parker Moore" | downcase }}
DOWNCASE
  end
end
