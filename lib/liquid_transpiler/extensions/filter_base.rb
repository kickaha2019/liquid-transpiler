# frozen_string_literal: true

class FilterBase
  def initialize(expression)
    @expression = expression
    @arguments  = []
  end

  def find_arguments(names)
    @expression.find_arguments(names)
    @arguments.each { |argument| argument.find_arguments(names) }
  end

  def setup(source)
    source.skip_space
    if source.next(':')
      param, term = LiquidTranspiler::Expression.parse1(source)
      @arguments << param
      while term == ','
        param, term = LiquidTranspiler::Expression.parse1(source)
        @arguments << param
      end
    else
      term = source.get
    end
    term
  end
end
