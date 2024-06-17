# frozen_string_literal: true

require_relative '../test_base'

class TestAndOrs < TestBase
  def test_and_or1
    compare(<<~AND_OR1)
      {% if true or false and false %}
        This evaluates to true, since the `and` condition is checked first.
      {% endif %}
    AND_OR1
  end

  def test_and_or2
    compare(<<~AND_OR2)
      {% if true and false and false or true %}
        This evaluates to false, since the tags are checked like this:
      
        true and (false and (false or true))
        true and (false and true)
        true and false
        false
      {% endif %}
    AND_OR2
  end
end
