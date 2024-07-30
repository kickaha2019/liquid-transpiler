# frozen_string_literal: true

module LiquidTranspiler
  module ParserExpressions
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

    def expect_expression
      formula, term = read_expression1

      while term == '|'
        filter, args = expect_name, []
        if clazz = filter_class(filter)
          formula = clazz.new(formula,self)
          term    = get
        else
          skip_space
          if next_string?(':')
            param, term = read_expression1
            args << param
            while term == ','
              param, term = read_expression1
              args << param
            end
          else
            term = get
          end
          formula = Operators::Filter.new(filter, formula, args)
        end
      end

      [formula, term]
    end

    def read_expression1
      expr, term = read_expression2

      if term == ':'
        unless expr.is_a?(Operators::Leaf)
          error(offset, 'Unexpected :')
        end

        if /^[a-z]/i =~ expr.token
          expr2, term = read_expression2
          [Operators::Parameter.new(expr.token, expr2), term]
        else
          error(offset, 'Unexpected :')
        end
      else
        [expr, term]
      end
    end

    def read_expression2
      elements = [read_expression3]
      term     = nil

      until (token = get).nil?
        case token
        when '['
          formula, term1 = read_expression1
          unless term1 == ']'
            error(offset, 'Expected ]')
          end
          elements[-1] = Operators::Array.new(elements[-1], formula)
        when '.'
          elements[-1] = Operators::Dereference.new(elements[-1], expect_name)
        when '|'
          term = token
          break
        else
          if OPERATORS[token]
            elements << token
            elements << read_expression3
          else
            term = token
            break
          end
        end
      end

      [to_formula(elements), term]
    end

    # rubocop:disable Style/CaseLikeIf
    def read_expression3
      token = get

      if token == '('
        from, type = read_expression1

        unless ['..', '...'].include? type
          error(@offset, 'Expecting .. or ...')
        end

        to, term = read_expression1
        unless term == ')'
          error(@offset, 'Expecting )')
        end

        Operators::Range.new(from, to, type)

      elsif token == "\n"
        error(offset, 'Bad syntax')

      elsif token.is_a?(String)
        Operators::Leaf.new(token)

      elsif token.is_a?(Integer)
        Operators::Leaf.new(token)

      elsif token.is_a?(Float)
        Operators::Leaf.new(token)

      elsif token.is_a?(Symbol)
        Operators::Leaf.new(token)

      else
        error(offset, 'Bad syntax')
      end
    end
    # rubocop:enable Style/CaseLikeIf

    def read_object_from_string(text)
      expression, term = nest(text).expect_expression
      error(@offset, "Unexpected: #{term}") if term
      expression
    end

    def read_parameter(offset)
      if get != ':'
        error(offset, 'Expected :')
      end
      expect_expression
    end

    def to_formula(elements)
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

      raise 'Internal error' if elements.size > 1

      elements[0]
    end
  end
end
