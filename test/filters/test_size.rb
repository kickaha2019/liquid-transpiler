require_relative '../test_base'

class TestSize < TestBase
  def test_size1
    fire( <<SIZE)
{{ "Ground control to Major Tom." | size }}
SIZE
  end

  def test_size2
    fire( <<SIZE)
{% assign my_array = "apples, oranges, peaches, plums" | split: ", " %}

{{ my_array.size }} 

{% if my_array.size > 3 %}
  Plenty of fruit!
{% endif %}
SIZE
  end
end
