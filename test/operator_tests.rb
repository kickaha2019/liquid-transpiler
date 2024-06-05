require_relative 'test_base'

class OperatorTests < TestBase
  def test_and_or1
    compare(<<AND_OR1)
{% if true or false and false %}
  This evaluates to true, since the `and` condition is checked first.
{% endif %}
AND_OR1
  end

  def test_and_or2
    compare(<<AND_OR2)
{% if true and false and false or true %}
  This evaluates to false, since the tags are checked like this:

  true and (false and (false or true))
  true and (false and true)
  true and false
  false
{% endif %}
AND_OR2
  end

  def test_contains1
    compare(<<CONTAINS1)
{% assign title = "Gage Blackwood" %}
{% if title contains "Gage" %}
  Agent 5
{% endif %}
CONTAINS1
  end

  def test_contains2
    compare(<<CONTAINS2)
{% assign names = "Gage Blackwood" | split: ' ' %}
{% if names contains "Gage" %}
  Agent 5
{% endif %}
CONTAINS2
  end

  def test_empty
    compare(<<EMPTY, {'array' => []})
{% if "" == empty %}
Empty string
{% endif %}
{% if array == empty %}
Empty array
{% endif %}
{% if unknown %}
Non-existing object
{% endif %}
EMPTY
  end

  def test_nil
    compare(<<NIL, {'hash' => {}})
{% if hash.missing %}
Wasn't nil
{% else %}
Was nil
{% endif %}    
{{ hash.nothing }}
NIL
  end

  def test_operators
    compare(<<OPERATORS)
{% false or 1 == 1 %}
Correct 1
{% endif %}
{% 1 != 2 and true %}
Correct 2
{% endif %}
{% false or 1 > -1 %}
Correct 3
{% endif %}
{% 1 < 2 and true %}
Correct 4
{% endif %}
{% false or 1 >= -1 %}
Correct 5
{% endif %}
{% 1 <= 2 and true %}
Correct 6
{% endif %}
OPERATORS
  end
end
