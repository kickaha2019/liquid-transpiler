# frozen_string_literal: true

require 'tzinfo'
require_relative '../../liquid_transpiled_methods'

module BridgetownTranspiledMethods
  include LiquidTranspiledMethods

  def filter_time_strftime(timezone,time,format)
    to_time(timezone,time).strftime(format)
  end

  def to_time(timezone,time)
    if time.is_a?( Time) || time.is_a?( DateTime)
      time
    else
      t = DateTime.parse(time.to_s)
      if timezone
        tz = TZInfo::Timezone.get( timezone)
        tz.local_time(t.year, t.month, t.day, t.hour, t.min, t.sec)
      else
        t
      end
    end
  end
end
