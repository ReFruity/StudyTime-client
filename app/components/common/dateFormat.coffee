# Component dependencies
{span} = React.DOM
{i18n} = requireComponents('/common', 'i18n')

# Support functions
padNumber = (num, digits, trim) ->
  neg = ""
  if num < 0
    neg = "-"
    num = -num
  num = "" + num
  num = "0" + num  while num.length < digits
  num = num.substr(num.length - digits)  if trim
  neg + num

dateGetter = (name, size, offset, trim) ->
  offset = offset or 0
  (date) ->
    value = date["get" + name]()
    value += offset  if offset > 0 or value > -offset
    value = 12  if value is 0 and offset is -12
    padNumber value, size, trim

dateStrGetter = (name, shortForm) ->
  (date) ->
    value = date["get" + name]()
    get = (if shortForm then "short_#{name}" else name)
    (i18n {}, "date.#{get.toLowerCase()}.#{value}")

timeZoneGetter = (date) ->
  zone = -1 * date.getTimezoneOffset()
  paddedZone = (if (zone >= 0) then "+" else "")
  paddedZone += padNumber(Math[(if zone > 0 then "floor" else "ceil")](zone / 60), 2) + padNumber(Math.abs(zone % 60),
    2)
  paddedZone

ampmGetter = (date, formats) ->
  (if date.getHours() < 12 then formats.AMPMS[0] else formats.AMPMS[1])

jsonStringToDate = (string) ->
  match = undefined
  if match = string.match(R_ISO8601_STR)
    date = new Date(0)
    tzHour = 0
    tzMin = 0
    dateSetter = (if match[8] then date.setUTCFullYear else date.setFullYear)
    timeSetter = (if match[8] then date.setUTCHours else date.setHours)
    if match[9]
      tzHour = int(match[9] + match[10])
      tzMin = int(match[9] + match[11])
    dateSetter.call date, int(match[1]), int(match[2]) - 1, int(match[3])
    h = int(match[4] or 0) - tzHour
    m = int(match[5] or 0) - tzMin
    s = int(match[6] or 0)
    ms = Math.round(parseFloat("0." + (match[7] or 0)) * 1000)
    timeSetter.call date, h, m, s, ms
    return date
  string

# Constants
R_ISO8601_STR = /^(\d{4})-?(\d\d)-?(\d\d)(?:T(\d\d)(?::?(\d\d)(?::?(\d\d)(?:\.(\d+))?)?)?(Z|([+-])(\d\d):?(\d\d))?)?$/
DATE_FORMATS_SPLIT = /((?:[^yMdHhmsaZE']+)|(?:'(?:[^']|'')*')|(?:E+|y+|M+|d+|H+|h+|m+|s+|a|Z))(.*)/
NUMBER_STRING = /^\-?\d+$/
DATE_FORMATS =
  yyyy: dateGetter("FullYear", 4)
  yy: dateGetter("FullYear", 2, 0, true)
  y: dateGetter("FullYear", 1)
  MMMM: dateStrGetter("Month")
  MMM: dateStrGetter("Month", true)
  MM: dateGetter("Month", 2, 1)
  M: dateGetter("Month", 1, 1)
  dd: dateGetter("Date", 2)
  d: dateGetter("Date", 1)
  HH: dateGetter("Hours", 2)
  H: dateGetter("Hours", 1)
  hh: dateGetter("Hours", 2, -12)
  h: dateGetter("Hours", 1, -12)
  mm: dateGetter("Minutes", 2)
  m: dateGetter("Minutes", 1)
  ss: dateGetter("Seconds", 2)
  s: dateGetter("Seconds", 1)
  sss: dateGetter("Milliseconds", 3)
  EEEE: dateStrGetter("Day")
  EEE: dateStrGetter("Day", true)
  a: ampmGetter
  Z: timeZoneGetter

getFormattedDate = (date, format) ->
  # Validate date and format
  if _.isString(date)
    if NUMBER_STRING.test(date)
      date = int(date)
    else
      date = jsonStringToDate(date)
  date = new Date(date) if _.isNumber(date)
  return (span {}, date + "")  unless _.isDate(date) or not format

  # Parse format
  elems = []
  parts = []
  fn = undefined
  match = undefined
  while format
    match = DATE_FORMATS_SPLIT.exec(format)
    if match
      parts = parts.concat(match.slice(1))
      format = parts.pop()
    else
      parts.push format
      format = null

  # Create localized date
  for value in parts
    fn = DATE_FORMATS[value]
    elems.push(if fn then fn(date) else (span {}, value.replace(/(^'|'$)/g, "").replace(/''/g, "'")))

  elems

# Component
module.exports = React.createClass
  propTypes:
    date: React.PropTypes.isRequired
    format: React.PropTypes.string

  render: ->
    (span {}, getFormattedDate(@props.date, @props.format))