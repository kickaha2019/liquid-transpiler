require_relative '../test_base'

class TestRender < TestBase
  def test_render1
    prepare( <<RENDER1, 'included.liquid')
Passed {{ threepwood }}
RENDER1
    compare("{% render 'included', threepwood:guybrush %}",
           {'guybrush' => 'Mighty pirate'})
  end

  def test_render2
    prepare( <<RENDER2, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER2
    compare( "{% render 'included', count:3, fruit:'apples' %}",
           {})
  end

  def test_render3
    prepare( <<RENDER3, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER3
    compare( "{% render 'included', count:counts[0],fruit:'apples' %}",
           {'counts' => [3]})
  end

  def test_render4
    prepare( <<RENDER4, 'included.liquid')
Passed {{ threepwood }}
RENDER4
    compare( "{% render 'included' with guybrush as threepwood %}",
           {'guybrush' => 'Mighty pirate'})
  end

  def test_render5
    prepare( <<RENDER5, 'included.liquid')
Passed {{ name }}
length {{ forloop.length }}
index {{ forloop.index }}
index0 {{ forloop.index0 }}
rindex {{ forloop.rindex }}
rindex0 {{ forloop.rindex0 }}
first {{ forloop.first }}
last {{ forloop.last }}
RENDER5
    compare( "{% render 'included' for names as name %}",
           {'names' => ['Guybrush','Threepwood']})
  end

  def test_render6
    prepare( <<RENDER4, 'included.liquid')
Passed {{ forename }} {{ surname }}
RENDER4
    compare( "{% render 'included', with forename:'Guybrush', surname:'Threepwood' %}",
             {})
  end
end

