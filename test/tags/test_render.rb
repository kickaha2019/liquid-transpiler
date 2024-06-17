require_relative '../test_base'

class TestRender < TestBase
  def test_render1
    prepare(<<RENDER1, 'included.liquid')
Passed {{ threepwood }}
RENDER1
    compare("{% render 'included', threepwood:guybrush %}",
            {'guybrush' => 'Mighty pirate'})
  end

  def test_render2
    prepare(<<RENDER2, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER2
    compare("{% render 'included', count:3, fruit:'apples' %}",
            {})
  end

  def test_render3
    prepare(<<RENDER3, 'included.liquid')
Passed {{ count }} {{ fruit }}
RENDER3
    compare("{% render 'included', count:counts[0],fruit:'apples' %}",
            {'counts' => [3]})
  end

  def test_render4
    prepare(<<RENDER4, 'included.liquid')
Passed {{ threepwood }}
RENDER4
    compare("{% render 'included' with guybrush as threepwood %}",
            {'guybrush' => 'Mighty pirate'})
  end

  def test_render5
    prepare(<<RENDER5, 'included.liquid')
Passed {{ name }}
length {{ forloop.length }}
index {{ forloop.index }}
index0 {{ forloop.index0 }}
rindex {{ forloop.rindex }}
rindex0 {{ forloop.rindex0 }}
first {{ forloop.first }}
last {{ forloop.last }}
RENDER5
    compare("{% render 'included' for names as name %}",
            {'names' => ['Guybrush','Threepwood']})
  end

  def test_render6
    prepare(<<RENDER6, 'included.liquid')
Passed {{ forename }} {{ surname }}
RENDER6
    compare("{% render 'included', with forename:'Guybrush', surname:'Threepwood' %}",
            {})
  end

  def test_render7
    prepare(<<RENDER7, 'included.liquid')
Passed {{ included.forename }} {{ included.surname }}
RENDER7
    compare("{% render 'included' with map %}",
            {'map' => {'forename' => 'Guybrush', 'surname'=>'Threepwood'}})
  end

  def test_render8
    prepare(<<RENDER8, 'included.liquid')
Passed {{ included.name }}
RENDER8
    compare("{% render 'included' for names %}",
            {'names' => [{'name' => 'Guybrush'},{'name' => 'Threepwood'}]})
  end

  def test_render9
    expect_error("{% render 'included' for names %}",
                 /Undefined render target/)
  end
end

