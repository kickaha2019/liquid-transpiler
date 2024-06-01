module TranspiledMethods
  def f_abs( value)
    if value.nil?
      return nil
    elsif value.is_a?( String)
      if /[\.]/ =~ value
        value = value.to_f
      else
        value = value.to_i
      end
    end
    value.abs
  end

  def f_append( value, postfix)
    value.nil? ? postfix : (postfix.nil? ? value : (value.to_s + postfix.to_s))
  end

  def f_at_least( value, limit)
    return nil if value.nil?
    (value < limit) ? limit : value
  end

  def f_at_most( value, limit)
    return nil if value.nil?
    (value < limit) ? value : limit
  end

  def f_capitalize( value)
    value.nil? ? nil : value.capitalize
  end

  def f_ceil( value)
    value.nil? ? nil : value.to_f.ceil
  end

  def f_compact( map)
    [].tap do |result|
      map.each {|entry| result << entry if entry}
    end
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

  def f_map( map, field)
    [].tap do |result|
      map.each {|entry| result << x(entry,field)}
    end
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
