# frozen_string_literal: true

require_relative '../test_base'

class TestObject < TestBase
  def test_object1
    compare('{{ hash.array[0] }}', {'hash' => {'array' => ['Hello World']}})
  end

  def test_object2
    compare('{{ hash.array[0].field }}',
            {'hash' => {'array' => [{'field' => 'Hello World'}]}})
  end

  def test_object5
    compare('{{ "Hello World" }}')
  end
end
