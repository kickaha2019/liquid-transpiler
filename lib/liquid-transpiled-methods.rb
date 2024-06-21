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
      @index.zero?
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
      @columns = 1_000_000_000
    end

    def col
      @column + 1
    end

    def col0
      @column
    end

    def col_first
      @column.zero?
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
        if @column.zero?
          @row += 1
        end
        yield entry
      end
    end

    def first
      @index.zero?
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

  def filter_abs(value)
    to_number(value).abs
  end

  def filter_append(value, postfix)
    value.to_s + postfix.to_s
  end

  def filter_at_least(value, limit)
    value = to_number(value)
    limit = to_number(limit)
    value < limit ? limit : value
  end

  def filter_at_most(value, limit)
    value = to_number(value)
    limit = to_number(limit)
    value < limit ? value : limit
  end

  def filter_capitalize(value)
    value.to_s.capitalize
  end

  def filter_ceil(value)
    to_number(value).ceil
  end

  def filter_compact(map)
    [].tap do |result|
      to_array(map).each { |entry| result << entry if entry }
    end
  end

  def filter_concat(map1, map2)
    [].tap do |result|
      to_array(map1).each { |entry| result << entry }
      to_array(map2).each { |entry| result << entry }
    end
  end

  def filter_date(date, format)
    if date.is_a?(String)
      case date
      when 'now'
        date = Date.today
      when 'today'
        date = Date.today
      else
        date = Date.parse(date)
      end
    end

    date.strftime(format)
  end

  def filter_default(value, defval, params = {})
    return value if params['allow_false'] && (value == false)
    return defval if value.respond_to?(EMPTY_METHOD) && value.empty?

    value || defval
  end

  def filter_divided_by(value, divisor)
    value = to_number(value)
    divisor = to_number(divisor)

    if divisor.is_a?(Integer)
      (value / divisor).floor
    else
      value / divisor
    end
  end

  def filter_downcase(value)
    value.to_s.downcase
  end

  def filter_escape(value)
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
      else
        letter
      end
    end
  end

  def filter_escape_once(value)
    value = value.to_s

    fragments, offset = [], 0
    while offset < value.size
      if m = value.match(/(&([a-z]+|#\d+);)/i, offset)
        fragments << filter_escape(value[offset...m.begin(0)])
        fragments << m[1]
        offset    = m.end(0)
      else
        fragments << filter_escape(value[offset..])
        break
      end
    end

    fragments.join('')
  end

  def filter_first(list)
    to_array(list)[0]
    # return list[0] if list.is_a?( Array)
    # list.each do |entry|
    #   return entry
    # end
    # nil
  end

  def filter_floor(value)
    to_number(value).floor
  end

  def filter_join(map, separator)
    [].tap do |result|
      to_array(map).each { |entry| result << entry }
    end.join(separator)
  end

  def filter_last(list)
    to_array(list)[-1]
  end

  def filter_lstrip(value)
    value.to_s.lstrip
  end

  def filter_minus(left, right)
    to_number(left) - to_number(right)
  end

  def filter_modulo(left, right)
    to_number(left) % to_number(right)
  end

  def filter_map(map, field)
    [].tap do |result|
      to_array(map).each { |entry| result << unpack(entry, field) }
    end
  end

  def filter_newline_to_br(value)
    value.to_s.gsub("\n", "<br />\n")
  end

  def filter_plus(left, right)
    to_number(left) + to_number(right)
  end

  def filter_prepend(value, prefix)
    prefix.to_s + value.to_s
  end

  def filter_remove(value, elide)
    value.to_s.gsub(elide.to_s, '')
  end

  def filter_remove_first(value, elide)
    value.to_s.sub(elide.to_s, '')
  end

  def filter_replace(value, was, now)
    value.to_s.gsub(was.to_s, now.to_s)
  end

  def filter_replace_first(value, was, now)
    value.to_s.sub(was.to_s, now.to_s)
  end

  def filter_reverse(list)
    to_array(list).reverse
  end

  def filter_round(value, places = 0)
    to_number(value).round(places)
  end

  def filter_rstrip(value)
    value.to_s.rstrip
  end

  def filter_size(list)
    if list.is_a?(String)
      list.size
    else
      to_array(list).size
    end
  end

  def filter_slice(list, start, length = 1)
    if list.is_a?(String)
      list.slice(start, length)
    else
      to_array(list).slice(start, length).join('')
    end
    # start = list.size + start if start < 0
    # if list.is_a?( String)
    #   list[start...(start+length)]
    # else
    #   list[start...(start+length)].join('')
    # end
  end

  def filter_sort(list, sort_by = nil)
    if sort_by
      to_array(list).sort_by { |entry| unpack(entry, sort_by) }
    else
      to_array(list).sort
    end
  end

  def filter_sort_natural(list, sort_by = nil)
    if sort_by
      to_array(list).sort_by { |entry| unpack(entry, sort_by).downcase }
    else
      to_array(list).sort_by(&:downcase)
    end
  end

  def filter_split(value, separator)
    value.to_s.split(separator.to_s)
  end

  def filter_strip(value)
    value.to_s.strip
  end

  def filter_strip_html(value)
    value.to_s.gsub(/<[^>]*>/, '')
  end

  def filter_strip_newlines(value)
    value.to_s.gsub("\n", '')
  end

  def filter_sum(list, sum_by = nil)
    if sum_by
      to_array(list).inject(0) { |r, e| r + unpack(e, sum_by) }
    else
      to_array(list).inject(:+)
    end
  end

  def filter_times(value, mult)
    to_number(value) * to_number(mult)
  end

  def filter_truncate(text, limit, etc = '...')
    return text if text.size <= limit

    text[0...(limit - etc.size)] + etc
  end

  def filter_truncatewords(text, limit, etc = '...')
    words = text.split(' ')
    return text if words.size <= limit

    words[0...limit].join(' ') + etc
  end

  def filter_uniq(list)
    to_array(list).uniq
  end

  def filter_upcase(value)
    value.to_s.upcase
  end

  def filter_url_decode(text)
    CGI.unescape text
  end

  def filter_url_encode(text)
    CGI.escape text
  end

  def filter_where(list, field, value = nil)
    if value.nil?
      [].tap do |results|
        to_array(list).each do |entry|
          results << entry if unpack(entry, field)
        end
      end
    else
      [].tap do |results|
        to_array(list).each do |entry|
          results << entry if unpack(entry, field) == value
        end
      end
    end
  end

  def forloop(list, old_forloop)
    unless list.is_a?(Array)
      list = list.to_a
    end

    Forloop.new(old_forloop, to_array(list))
  end

  def method_missing(symbol, * args)
    if m = /^filter_(.*)$/.match(symbol.to_s)
      raise "Undefined filter: #{m[1]}"
    end

    super(symbol, args)
  end

  def operator_contains(text, search)
    !text.index(search).nil?
  end

  def operator_eq(left, right)
    return true if left == right

    if left == :empty
      right.empty?
    elsif right == :empty
      left.empty?
    else
      false
    end
  end

  def operator_ne(left, right)
    if left == :empty
      !right.empty?
    elsif right == :empty
      !left.empty?
    else
      left != right
    end
  end

  def respond_to_missing?
    true
  end

  def tablerow(list)
    # unless list.is_a?( Array)
    #   list = list.to_a
    # end
    #
    Tablerowloop.new(to_array(list))
  end

  def to_array(list)
    list.to_a
  end

  def to_number(value)
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

  def to_string(thing)
    thing.to_s
  end

  def unpack(thing, field)
    if thing.is_a?(Hash)
      thing[field]
    else
      thing.send(field.to_sym)
    end
  end
end
