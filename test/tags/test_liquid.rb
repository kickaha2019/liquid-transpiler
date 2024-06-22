# frozen_string_literal: true

require_relative '../test_base'

class TestLiquid < TestBase
  def test_liquid1
    compare(<<~LIQUID1)
      {% liquid
        # this is a comment
        assign topic = 'Learning about comments!'
        echo topic
      %}
    LIQUID1
  end

  def test_liquid2
    compare(<<~LIQUID2)
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

  def test_liquid3
    compare(<<~LIQUID3, {'content' => [{'type' => 'gallery'}]})
      {%
        liquid
        assign galleries = content | where: "type", "gallery"
        if galleries.size > 0
          assign overlays = true
        else
          assign insets    = content | where: "type", "inset"
          if insets.size > 0
              assign overlays = true
          else
              assign overlays = false
          endif
        endif
      %}
      {{ overlays }}
    LIQUID3
  end

  def test_liquid_error1
    expect_error(<<~LIQUID_ERROR1, /Bad syntax/)
      {% liquid#{' '}
        assign x =#{' '}
        123
      %}
      {{ x }}
    LIQUID_ERROR1
  end

  def test_liquid_error2
    expect_error(<<~LIQUID_ERROR2, /Unexpected echo/)
      {% liquid echo "Hello" echo "World" %}
    LIQUID_ERROR2
  end
end
