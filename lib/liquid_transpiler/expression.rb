# frozen_string_literal: true

# rubocop:disable Layout/HashAlignment

module LiquidTranspiler
  class Expression
    OPERATORS = {
      :and      => ['And',                 true],
      :contains => ['Contains',            false],
      :or       => ['Or',                  true],
      '=='      => ['Equals',              false],
      '!='      => ['NotEquals',           false],
      '<>'      => ['NotEquals',           false],
      '>'       => ['GreaterThan',         false],
      '>='      => ['GreaterThanOrEquals', false],
      '<'       => ['LessThan',            false],
      '<='      => ['LessThanOrEquals',    false]
    }.freeze

    def self.parse(source)
      formula, term = parse1(source)

      while term == '|'
        filter, args = source.expect_name, []
        if clazz = source.filter_class(filter)
          formula = clazz.new(formula)
          term    = formula.setup(source)
        else
          source.skip_space
          if source.next(':')
            param, term = parse1(source)
            args << param
            while term == ','
              param, term = parse1(source)
              args << param
            end
          else
            term = source.get
          end
          formula = Operators::Filter.new(filter, formula, args)
        end
      end

      [formula, term]
    end

    def self.parse_parameter(offset, source)
      if source.get != ':'
        source.error(offset, 'Expected :')
      end
      parse(source)
    end

    def self.parse1(source)
      expr, term = parse2(source)

      if term == ':'
        unless expr.is_a?(Operators::Leaf)
          source.error(source.offset, 'Unexpected :')
        end

        if /^[a-z]/i =~ expr.token
          expr2, term = parse2(source)
          [Operators::Parameter.new(expr.token, expr2), term]
        else
          source.error(source.offset, 'Unexpected :')
        end
      else
        [expr, term]
      end
    end

    def self.parse2(source)
      elements = [parse3(source)]
      term     = nil

      until (token = source.get).nil?
        case token
        when '['
          formula, term1 = parse1(source)
          unless term1 == ']'
            source.error(source.offset, 'Expected ]')
          end
          elements[-1] = Operators::Array.new(elements[-1], formula)
        when '.'
          elements[-1] = Operators::Dereference.new(elements[-1], source.expect_name)
        when '|'
          term = token
          break
        else
          if OPERATORS[token]
            elements << token
            elements << parse3(source)
          else
            term = token
            break
          end
        end
      end

      [to_formula(elements), term]
    end

    # rubocop:disable Style/CaseLikeIf
    def self.parse3(source)
      token = source.get

      if token == '('
        from, type = parse1(source)

        unless ['..', '...'].include? type
          source.error(@offset, 'Expecting .. or ...')
        end

        to, term = parse1(source)
        unless term == ')'
          source.error(@offset, 'Expecting )')
        end

        Operators::Range.new(from, to, type)

      elsif token == "\n"
        source.error(source.offset, 'Bad syntax')

      elsif token.is_a?(String)
        Operators::Leaf.new(token)

      elsif token.is_a?(Integer)
        Operators::Leaf.new(token)

      elsif token.is_a?(Float)
        Operators::Leaf.new(token)

      elsif token.is_a?(Symbol)
        Operators::Leaf.new(token)

      else
        source.error(source.offset, 'Bad syntax')
      end
    end
    # rubocop:enable Style/CaseLikeIf

    def self.to_formula(elements)
      i = 1
      while i + 1 < elements.size
        if (op = OPERATORS[elements[i]]) && (!op[1])
          elements.delete_at(i)
          rhs = elements.delete_at(i)
          clazz = Object.const_get("LiquidTranspiler::Operators::#{op[0]}")
          elements[i - 1] = clazz.new(elements[i - 1], rhs)
        else
          i += 2
        end
      end

      i = elements.size - 2
      while i.positive?
        if op = OPERATORS[elements[i]]
          elements.delete_at(i)
          rhs = elements.delete_at(i)
          clazz = Object.const_get("LiquidTranspiler::Operators::#{op[0]}")
          elements[i - 1] = clazz.new(elements[i - 1], rhs)
        else
          break
        end
        i -= 2
      end

      raise 'Dev' if elements.size > 1

      elements[0]
    end
  end
end

# rubocop:enable Layout/HashAlignment
