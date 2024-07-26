# frozen_string_literal: true

require_relative '../test_base'
require_relative '../../lib/liquid_transpiler/extensions/bridgetown_where_exp'

class TestWhereExp < TestBase
  MEMBERS = [{'graduation_year' => 2013, 'name' => 'Anna'},
             {'graduation_year' => 2014, 'name' => 'Betty'},
             {'graduation_year' => 2015, 'name' => 'Christine'}].freeze

  def test_where_exp1
    code = <<~CODE1
      {{ members |#{' '}
         where_exp:"member", "member.graduation_year == 2014" |#{' '}
         map: "name" |
         join: " and " }}
    CODE1
    expect(code,
           {'members' => MEMBERS},
           'Betty')
  end

  def test_where_exp2
    code = <<~CODE2
      {{ members |#{' '}
         where_exp:"member", "member.graduation_year < 2015" |#{' '}
         map: "name" |
         join: " and " }}
    CODE2
    expect(code,
            {'members' => MEMBERS},
            'Anna and Betty')
  end

  def test_where_exp3
    code = <<~CODE3
      {{ members |#{' '}
         where_exp:"member", "member.name contains 'Chris'" |#{' '}
         map: "name" |
         join: " and " }}
    CODE3
    expect(code,
            {'members' => MEMBERS},
            'Christine')
  end

  def transpile(dir, path, clazz)
    @transpiler.define_filter('where_exp',
                              LiquidTranspiler::Extensions::BridgetownWhereExp)
    @transpiler.transpile_dir(dir, path, class:clazz)
  end
end
