module TranspiledMethods
  def f_at_least( value, *args)
    (value < args[0]) ? args[0] : value
  end

  def f_at_most( value, *args)
    (value < args[0]) ? value : args[0]
  end

  def f_divided_by( value, *args)
    if args[0].is_a?( Integer)
      (value / args[0]).floor
    else
      value / args[0]
    end
  end

  def f_floor( value)
    if value.is_a?( String)
      value = value.to_f
    end
    value.floor
  end

  def f_split( value, *args)
    value.split( args[0])
  end

  def f_times( value, *args)
    value * args[0]
  end

  def t( thing)
    thing.to_s
  end

  def x( context, *args)
    args.each do |arg|
      if context.is_a?( Hash)
        context = context[arg]
      else
        context = context.send( arg.to_sym)
      end
    end
    context
  end
end
