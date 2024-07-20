# frozen_string_literal: true

require 'tzinfo'
require_relative '../../liquid_transpiled_methods'

module BridgetownTranspiledMethods
  include LiquidTranspiledMethods

  def filter_date_to_string(timezone, time, month_format, *options)
    t = to_time(timezone, time)

    day_format = '%d'
    if options.include? 'ordinal'
      case t.day
      when 1
        ordinal = 'st'
      when 2
        ordinal = 'nd'
      when 3
        ordinal = 'rd'
      when 21
        ordinal = 'st'
      when 22
        ordinal = 'nd'
      when 23
        ordinal = 'rd'
      when 31
        ordinal = 'st'
      else
        ordinal = 'th'
      end
      day_format = '%-d' + ordinal
      if options.include? 'US'
        day_format += ','
      end
    end

    if options.include? 'US'
      format = "#{month_format} #{day_format} %Y"
    else
      format = "#{day_format} #{month_format} %Y"
    end

    t.strftime(format)
  end

  def filter_time_strftime(timezone, time, format)
    to_time(timezone, time).strftime(format)
  end

  def to_time(timezone, time)
    if time.is_a?(Time) || time.is_a?(DateTime)
      time
    else
      t = DateTime.parse(time.to_s)
      if timezone
        tz = TZInfo::Timezone.get(timezone)
        tz.local_time(t.year, t.month, t.day, t.hour, t.min, t.sec)
      else
        t
      end
    end
  end
end
