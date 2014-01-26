{span, div, ul, li, nav, a, i, h2, h3} = React.DOM
{classSet} = React.addons
{i18n, viewType, dateFormat} = requireComponents('/common', 'i18n', 'viewType', 'dateFormat')

##
# Decorator component for showing cell content
#
SchedCell = React.createClass
  render: ->
    {number, curr, dow} = @props
    (div {className: classSet('sched-cell-wrap': true, 'current': curr.number == number and curr.dow == dow)}, [
      (div {className: 'sched-cell'}, @props.children)
    ])

##
# Decorator component for showing cell details
# It renders inside some custom componen, pushed to
# main schedule component
#
SchedDetails = React.createClass
  render: ->
    (div {className: 'sched-details'}, [
      @props.children
    ])

##
# Component for showing data cells (classes, or free places),
# for each day in block for given class number
#
SchedDataRow = React.createClass
  minutesToHours: (input) ->
    value = parseInt(input)
    hours = Math.floor(value / 60)
    minutes = value - hours * 60
    return (if hours < 10 then "0"+hours else hours) + ":" + (if minutes < 10 then "0"+minutes else minutes)

  render: ->
    {sched, timing, number, cellElem, detailsElem, curr, dows, details, cellProps} = @props
    (div {className: classSet('container data-row':yes, 'exclude-co': details and details.dow in dows and details.number == number)}, [
      (div {className: 'row'}, [
        (div {className: classSet('row-number': true, 'current': curr.number == number and curr.dow in dows)}, [
          (h2 {className: 'number-id'}, [number])
          (h3 {className: 'number-time'}, @minutesToHours(timing[number].start))
        ])
        (@props.dows.map (dow)->
          data = if sched[dow] and sched[dow][number] then sched[dow][number] else []
          (SchedCell {dow: dow, number: number, curr: curr}, [
            (cellElem _.assign({dow: dow, number: number, data: data, date: curr.dates[dow]}, cellProps or {}))
          ])
        )
        ((if details and detailsElem and details.dow in dows and details.number == number
          (SchedDetails {}, [
            (detailsElem _.assign({data: details.data}, cellProps or {}))
          ])
        else
          undefined
        ))
      ])
    ])

##
# Show day of week names in block
#
SchedHeaderRow = React.createClass
  render: ->
    {curr, dows} = @props
    (div {className: 'container header-row', key: "sched.header.#{dows.join('.')}"}, [
      (div {className: 'row'}, [
        (dows.map (dow) ->
          (div {key: "sched.header.#{dow}", className: classSet('header-day': true, 'current': curr.dow == dow)},
            [
              (h2 {}, [
                (dateFormat {className: 'dow', date: curr.dates[dow], format: "EEEE"})
                (dateFormat {className: 'date', date: curr.dates[dow], format: "dd MMM"})
              ])
            ])
        )
      ])
    ])


##
# Component for showing block with few days of week (block of days)
#
SchedBlock = React.createClass
  render: ->
    self = @
    (div {className: 'sched-block'}, [
      self.transferPropsTo(SchedHeaderRow {})
      (['1', '2', '3', '4', '5', '6'].map (number) ->
        self.transferPropsTo(SchedDataRow {number: number})
      )
    ])

##
# Main schedule component. Provides flexible interface
# for showing schedule grid with what ever you want in cells.
#
# One required prop is `cellElem`, that will be used
# as element in each cell of grid. This element gets
# from schedule `dow`, `number`, `data` and `date` params.
#
# You can specify `detailsElem`, if you want to show some
# details about cells. If this param presented and presented
# another param called `details` (with cell coordinates and data)
# this component adds details element above given cell coordinates.
#
# Component is responsive to desktop and mobile versions.
# On desktop it showes three columns of days, on mobile - one column.
#
module.exports = React.createClass
  mixins: [viewType]

  propTypes:
    cellElem: React.PropTypes.func.isRequired,
    weekDate: React.PropTypes.instanceOf(Date)
    sched: React.PropTypes.object
    timing: React.PropTypes.object
    detailsElem: React.PropTypes.func,
    cellProps: React.PropTypes.object
    details: (propValue, propName) ->
      details = propValue[propName]
      if details and (not details.dow or not details.number or not details.data)
        throw new Error('Mallformed details prop. Must contain `dow`, `number` and `data` fields')

  getDefaultProps: ->
    weekDate: new Date()
    timing: {}
    sched: {}

  # Calculate current class number based on timing and current time
  getCurrentClass: ->
    currentClass = undefined
    date = new Date()
    mins = date.getHours() * 60 + date.getMinutes()
    greeter_count = 0

    for clazz of @props.timing
      if @props.timing[clazz] and mins >= @props.timing[clazz].start
        currentClass = clazz
        greeter_count++
    if greeter_count == @props.timing.length
      currentClass = undefined

    return currentClass

  # Calculate Date for each day of current week
  getWeekDates: ->
    dowDates = {}
    dows = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    bw = {0: 6, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5}
    now = new Date(@props.weekDate)

    for day in [0..6]
      distance = day - bw[now.getDay()]
      now.setDate(now.getDate() + distance)
      dowDates[dows[day]] = new Date(now)

    return dowDates

  # Calculate current week parity
  getWeekParity: ->
    d = new Date(@props.weekDate)
    d.setHours(0, 0, 0)
    d.setDate(d.getDate() + 4 - (d.getDay() || 7))
    yearStart = new Date(d.getFullYear(), 0, 1)
    weekNo = Math.ceil(( ( (d - yearStart) / 86400000) + 1) / 7)
    return if weekNo % 2 == 0 then 'even' else 'odd'

  # Calculate current day of week
  getCurrentDow: ->
    ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][new Date().getDay()]

  # Renders the schedule based on view type (mobile or desktop),
  # provided from mixin `viewType`
  render: ->
    # Calculate currents
    curr =
      number: @getCurrentClass()
      dow: @getCurrentDow()
      dates: @getWeekDates()
      parity: @getWeekParity()

    # Get blocks for desktop and mobile
    blocks = if @viewType == "desktop" then [
      ['Mon', 'Tue', 'Wed'],
      ['Thu', 'Fri', 'Sat']
    ] else [
      ['Mon'],
      ['Tue'],
      ['Wed'],
      ['Thu'],
      ['Fri'],
      ['Sat']
    ]

    # Render schedule
    self = @
    (div {className: "schedule #{@viewType} week-#{curr.parity}"}, [
      (blocks.map (block)->
        self.transferPropsTo(SchedBlock {dows: block, curr: curr})
      )
    ])
