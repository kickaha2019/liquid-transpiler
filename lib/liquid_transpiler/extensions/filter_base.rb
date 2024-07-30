# frozen_string_literal: true

class FilterBase
  def initialize(expression, parser)
    @expression = expression
    @arguments  = []

    parser.skip_space
    if parser.next_string?(':')
      param, term = parser.read_expression1
      @arguments << param
      while term == ','
        param, term = parser.read_expression1
        @arguments << param
      end
      parser.unget term
    end
  end

  def find_arguments(names)
    @expression.find_arguments(names)
    @arguments.each { |argument| argument.find_arguments(names) }
  end
end
