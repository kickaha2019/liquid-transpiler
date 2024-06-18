# frozen_string_literal: true

require 'date'
require 'uri'
require 'cgi'

module TranspiledMethods
  EMPTY_METHOD = 'empty?'.to_sym

  class Forloop
    def initialize(parent, data)
      @parent = parent
      @data   = data
      @index  = -1
    end

    def each
      @data.each do |entry|
        @index += 1
        yield entry
      end
    end

    def empty?
      @data.empty?
    end

    def first
      @index == 0
    end

    def index
      1 + @index
    end

    def index0
      @index
    end

    def last
      @index == (@data.size - 1)
    end

    def length
      @data.size
    end

    def limit(setting)
      @data = @data[0...setting] if setting < @data.size
    end

    def offset(setting)
      @data = @data[setting..]
    end

    def parentloop
      @parent
    end

    def reverse
      @data = @data.reverse
    end

    def rindex
      @data.size - @index
    end

    def rindex0
      @data.size - @index - 1
    end
  end

  class Tablerowloop
    def initialize(data)
      @data    = data
      @column  = -1
      @row     = -1
      @index   = -1
      @columns = 1000000000
    end

    def col
      @column + 1
    end

    def col0
      @column
    end

    def col_first
      @column == 0
    end

    def col_last
      ((@column + 1) >= @columns) # || last
    end

    def columns(setting)
      @columns = setting
    end

    def each
      @data.each do |entry|
        @index += 1
        @column += 1
        @column = 0 if @column >= @columns
        if @column == 0
          @row += 1
        end
        yield entry
      end
    end

    def first
      @index == 0
    end

    def index
      1 + @index
    end

    def index0
      @index
    end

    def last
      @index == (@data.size - 1)
    end

    def length
      @data.size
    end

    def limit(setting)
      @data = @data[0...setting] if setting < @data.size
    end

    def offset(setting)
      @data = @data[setting..]
    end

    def rindex
      @data.size - @index
    end

    def rindex0
      @data.size - @index - 1
    end

    def row
      @row + 1
    end
  end

  def f(list, old_forloop)
    unless list.is_a?(Array)
      list = list.to_a
    end

    Forloop.new(old_forloop, l(list))
  end

  def f_abs(value)
    n(value).abs
  end

  def f_append(value, postfix)
    value.to_s + postfix.to_s
  end

  def f_at_least(value, limit)
    value = n(value)
    limit = n(limit)
    (value < limit) ? limit : value
  end

  def f_at_most(value, limit)
    value = n(value)
    limit = n(limit)
    (value < limit) ? value : limit
  end

  def f_capitalize(value)
    value.to_s.capitalize
  end

  def f_ceil(value)
    n(value).ceil
  end

  def f_compact(map)
    [].tap do |result|
      l(map).each { |entry| result << entry if entry }
    end
  end

  def f_concat(map1, map2)
    [].tap do |result|
      l(map1).each { |entry| result << entry }
      l(map2).each { |entry| result << entry }
    end
  end

  def f_date(date, format)
    if date.is_a?(String)
      case date
      when 'now'
        date = Date::today
      when 'today'
        date = Date::today
      else
        date = Date.parse(date)
      end
    end

    date.strftime(format)
  end

  def f_default(value, defval, params = {})
    return value if params['allow_false'] && (value == false)
    return defval if value.respond_to?(EMPTY_METHOD) && value.empty?

    value || defval
  end

  def f_divided_by(value, divisor)
    value = n(value)
    divisor = n(divisor)

    if divisor.is_a?(Integer)
      (value / divisor).floor
    else
      value / divisor
    end
  end

  def f_downcase(value)
    value.to_s.downcase
  end

  def f_escape(value)
    value = value.to_s
    value.gsub(/['&"<>]/) do |letter|
      case letter
      when '"'
        '&quot;'
      when '<'
        '&lt;'
      when '>'
        '&gt;'
      when "'"
        '&#39;'
      when '&'
        '&amp;'
      end
    end
  end

  def f_escape_once(value)
    value = value.to_s

    fragments, offset = [], 0
    while offset < value.size
      if m = value.match(/(&([a-z]+|#\d+);)/i, offset)
        fragments << f_escape(value[offset...m.begin(0)])
        fragments << m[1]
        offset    = m.end(0)
      else
        fragments << f_escape(value[offset..])
        break
      end
    end

    fragments.join('')
  end

  def f_first(list)
    l(list)[0]
    # return list[0] if list.is_a?( Array)
    # list.each do |entry|
    #   return entry
    # end
    # nil
  end

  def f_floor(value)
    n(value).floor
  end

  def f_join(map, separator)
    [].tap do |result|
      l(map).each { |entry| result << entry }
    end.join(separator)
  end

  def f_last(list)
    l(list)[-1]
  end

  def f_lstrip(value)
    value.to_s.lstrip
  end

  def f_minus(left, right)
    n(left) - n(right)
  end

  def f_modulo(left, right)
    n(left) % n(right)
  end

  def f_map(map, field)
    [].tap do |result|
      l(map).each { |entry| result << x(entry, field) }
    end
  end

  def f_newline_to_br(value)
    value.to_s.gsub("\n", "<br />\n")
  end

  def f_plus(left, right)
    n(left) + n(right)
  end

  def f_prepend(value, prefix)
    prefix.to_s + value.to_s
  end

  def f_remove(value, elide)
    value.to_s.gsub(elide.to_s, '')
  end

  def f_remove_first(value, elide)
    value.to_s.sub(elide.to_s, '')
  end

  def f_replace(value, was, now)
    value.to_s.gsub(was.to_s, now.to_s)
  end

  def f_replace_first(value, was, now)
    value.to_s.sub(was.to_s, now.to_s)
  end

  def f_reverse(list)
    l(list).reverse
  end

  def f_round(value, places = 0)
    n(value).round(places)
  end

  def f_rstrip(value)
    value.to_s.rstrip
  end

  def f_size(list)
    if list.is_a?(String)
      list.size
    else
      l(list).size
    end
  end

  def f_slice(list, start, length = 1)
    if list.is_a?(String)
      list.slice(start, length)
    else
      l(list).slice(start, length).join('')
    end
    # start = list.size + start if start < 0
    # if list.is_a?( String)
    #   list[start...(start+length)]
    # else
    #   list[start...(start+length)].join('')
    # end
  end

  def f_sort(list, sort_by = nil)
    if sort_by
      l(list).sort_by { |entry| x(entry, sort_by) }
    else
      l(list).sort
    end
  end

  def f_sort_natural(list, sort_by = nil)
    if sort_by
      l(list).sort_by { |entry| x(entry, sort_by).downcase }
    else
      l(list).sort_by { |entry| entry.downcase }
    end
  end

  def f_split(value, separator)
    value.to_s.split(separator.to_s)
  end

  def f_strip(value)
    value.to_s.strip
  end

  def f_strip_html(value)
    value.to_s.gsub(/<[^>]*>/, '')
  end

  def f_strip_newlines(value)
    value.to_s.gsub("\n", '')
  end

  def f_sum(list, sum_by = nil)
    if sum_by
      l(list).inject(0) { |r, e| r + x(e, sum_by) }
    else
      l(list).inject(:+)
    end
  end

  def f_times(value, mult)
    n(value) * n(mult)
  end

  def f_truncate(text, limit, etc = '...')
    return text if text.size <= limit

    text[0...(limit - etc.size)] + etc
  end

  def f_truncatewords(text, limit, etc = '...')
    words = text.split(' ')
    return text if words.size <= limit

    words[0...limit].join(' ') + etc
  end

  def f_uniq(list)
    l(list).uniq
  end

  def f_upcase(value)
    value.to_s.upcase
  end

  def f_url_decode(text)
    CGI.unescape text
  end

  def f_url_encode(text)
    CGI.escape text
  end

  def f_where(list, field, value = nil)
    if value.nil?
      [].tap do |results|
        l(list).each do |entry|
          results << entry if x(entry, field)
        end
      end
    else
      [].tap do |results|
        l(list).each do |entry|
          results << entry if x(entry, field) == value
        end
      end
    end
  end

  def l(list)
    list.to_a
  end

  def n(value)
    if value.is_a?(String)
      if value.index('.').nil?
        value.to_i
      else
        value.to_f
      end
    else
      value
    end
  end

  def o_contains(text, search)
    !text.index(search).nil?
  end

  def o_eq(left, right)
    return true if left == right

    if left == :empty
      right.empty?
    elsif right == :empty
      left.empty?
    else
      false
    end
  end

  def o_ne(left, right)
    if left == :empty
      !right.empty?
    elsif right == :empty
      !left.empty?
    else
      left != right
    end
  end

  def t(thing)
    thing.to_s
  end

  def tablerow(list)
    # unless list.is_a?( Array)
    #   list = list.to_a
    # end
    #
    Tablerowloop.new(l(list))
  end

  def x(thing, field)
    if thing.is_a?(Hash)
      thing[field]
    else
      thing.send(field.to_sym)
    end
  end
end
