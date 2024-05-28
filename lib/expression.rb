require_relative 'operators/array'
require_relative 'operators/leaf'

module LiquidTranspiler
  class Expression
    OPERATORS = {
      'and' => [:eat_logical, 'o_and'],
      'or'  => [:eat_logical, 'o_or'],
      '.'   => [:eat_dereference],
      '|'   => [:eat_filter]
    }

    def initialize( formula)
      @formula = formula
    end

    def self.check_literal_or_variable( source, element)
      if element.nil?
        raise TranspilerError.new( source.offset, 'Expected literal or variable')
      end
      if OPERATORS[element]
        raise TranspilerError.new( source.offset, 'Unexpected operator')
      end
      unless /^['"a-z0-9]/i =~ element
        raise TranspilerError.new( source.offset, 'Expected literal or variable')
      end
      Operators::Leaf.new( element)
    end

    def deduce_arguments
      @formula.deduce_arguments
    end

    def self.parse( source)
      formula, term = parse1( source)
      raise 'Dev' unless term.nil?
      return formula, term
    end

    def self.parse1( source)
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
          elements[-1] = Operators::Dereference( elements[-1], source.get_name)
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
      raise 'Dev' if elements.size > 1
      elements[0]
    end
  end
end