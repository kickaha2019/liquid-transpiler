module LiquidTranspiler
  class TranspilerExpression
    OPERATORS = {
      'and' => [:eat_logical, 'o_and'],
      'or'  => [:eat_logical, 'o_or'],
      '=='   => ['Equals', false],
      '>'    => ['GreaterThan', false]
    }

    def self.check_literal_or_variable( source, element)
      if element.nil?
        raise TranspilerError.new( source.offset, 'Expected literal or variable')
      end
      if OPERATORS[element]
        raise TranspilerError.new( source.offset, 'Unexpected operator')
      end
      unless (/^['"a-z0-9]/i =~ element) ||
             ((/^[\.\-]/ =~ element) && (element.size > 1))
        raise TranspilerError.new( source.offset, 'Expected literal or variable')
      end
      Operators::Leaf.new( element)
    end

    def self.parse( source)
      formula, term = parse1( source)

      while term == '|'
        filter, args = source.expect_name, []
        source.skip_space
        if source.next(':')
          param, term = parse1( source)
          args << param
          while term == ','
            param, term = parse1( source)
            args << param
          end
        else
          term = source.get
        end
        formula = Operators::Filter.new( filter, formula, args)
      end

      raise 'Dev' unless term.nil?
      return formula, term
    end

    def self.parse1( source)
      expr, term = parse2( source)

      if term == ':'
        unless expr.is_a?( Operators::Leaf)
          raise TranspilerError.new( source.offset, 'Unexpected :')
        end

        if /^[a-z]/i =~ expr.token
          expr2, term = parse2( source)
          return Operators::Parameter.new( expr.token, expr2), term
        else
          raise TranspilerError.new( source.offset, 'Unexpected :')
        end
      else
        return expr, term
      end
    end

    def self.parse2( source)
      elements = [check_literal_or_variable( source, source.get)]
      term     = nil

      while token = source.get
        case token
        when '['
          formula, term1 = parse1( source)
          unless term1 == ']'
            raise TranspilerError.new( source.offset, 'Expected ]')
          end
          elements[-1] = Operators::Array( elements[-1], formula)
        when '.'
          elements[-1] = Operators::Dereference.new( elements[-1], source.get_name)
        when '|'
          term = token
          break
        else
          if OPERATORS[token]
            elements << token
            elements << check_literal_or_variable( source, source.get)
          else
            term = token
            break
          end
        end
      end

      return to_formula( elements), term
    end

    def self.to_formula( elements)
      i = 1
      while i+1 < elements.size
        if (op = OPERATORS[elements[i]]) && (! op[1])
          elements.delete_at(i)
          rhs = elements.delete_at(i)
          clazz = Object.const_get( 'LiquidTranspiler::Operators::' + op[0])
          elements[i-1] = clazz.new( elements[i-1], rhs)
        else
          i += 2
        end
      end

      raise 'Dev' if elements.size > 1
      elements[0]
    end
  end
end