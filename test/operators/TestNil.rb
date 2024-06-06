require_relative '../test_base'

class TestNil < TestBase
  def test_nil
    compare(<<NIL, {'hash' => {}})
{% if hash.missing %}
Wasn't nil
{% else %}
Was nil
{% endif %}    
{{ hash.nothing }}
{% if unknown %}
Non-existing object
{% endif %}
NIL
  end
end

