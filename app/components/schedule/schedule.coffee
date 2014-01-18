{span, div, ul, li, nav, a, i, h2, h3} = React.DOM
{classSet} = React.addons
{i18n, viewType} = requireComponents('/common', 'i18n', 'viewType')

SchedCell = React.createClass
  render: ->
    {number, curr, dow} = @props
    (div {className: classSet('sched-cell': true, 'current': curr.number == number and curr.dow == dow)}, [
      @props.children
    ])

SchedDetails = React.createClass
  render: ->
    (div {className: 'sched-details'}, [
      @props.children
    ])

SchedDataRow = React.createClass
  render: ->
    {sched, number, cellElem, detailsElem, curr, dows, details, date} = @props
    (div {className: 'container data-row'}, [
      (div {className: 'row'}, [
        (div {className: classSet('row-number': true, 'current': curr.number == number and curr.dow in dows)}, [
          (h2 {className: 'number-id'}, [number])
          (h3 {className: 'number-time'}, [number])
        ])
        (@props.dows.map (dow)->
          data = if sched[dow] and sched[dow][number] then sched[dow][number] else {}
          (SchedCell {dow: dow, number: number, curr: curr}, [
            (cellElem {dow: dow, number: number, date: date, data: data})
          ])
        )
        ((if details and detailsElem and details.dow in dows and details.number == number
          (SchedDetails {}, [(detailsElem {data: details.data})])
        else
          undefined
        ))
      ])
    ])

SchedHeaderRow = React.createClass
  render: ->
    {curr} = @props
    (div {className: 'container header-row'}, [
      (div {className: 'row'}, [
        (@props.dows.map (dow) ->
          (div {key: "sched.header.#{dow}", className: classSet('header-day col-sm-4': true, 'current': curr.dow == dow)},
            [
              (h2 {}, [
                (i18n {}, "schedule.dow.#{dow}")
              ])
            ])
        )
      ])
    ])

SchedBlock = React.createClass
  render: ->
    self = @
    (div {className: 'sched-block'}, [
      self.transferPropsTo(SchedHeaderRow {})
      (['1', '2', '3', '4', '5', '6'].map (number) ->
        self.transferPropsTo(SchedDataRow {number: number})
      )
    ])

module.exports = React.createClass
  mixins: [viewType]
  propTypes:
    date: React.PropTypes.instanceOf(Date)
    sched: React.PropTypes.object
    timing: React.PropTypes.object
    detailsElem: React.PropTypes.func,
    cellElem: React.PropTypes.func.isRequired,
    details: (propValue, propName) ->
      details = propValue[propName]
      if details and (not details.dow or not details.number or not details.data)
        throw new Error('Mallformed details prop. Must contain `dow`, `number` and `data` fields')

  getCurrentClass: ->
    currentClass = undefined
    mins = @props.date.getHours() * 60 + @props.date.getMinutes()
    greeter_count = 0

    for clazz of @props.timing
      if @props.timing[clazz] and mins >= @props.timing[clazz].start
        currentClass = clazz
        greeter_count++
    if greeter_count == @props.timing.length
      currentClass = undefined

    return currentClass

  getWeekDates: ->
    dowDates = {}
    dows = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    bw = {0: 6, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5}
    now = new Date(@props.date)

    for day in [0..6]
      distance = day - bw[now.getDay()]
      now.setDate(now.getDate() + distance)
      dowDates[dows[day]] = new Date(now)

    return dowDates

  getWeekParity: ->
    d = new Date(@props.date)
    d.setHours(0, 0, 0)
    d.setDate(d.getDate() + 4 - (d.getDay() || 7))
    yearStart = new Date(d.getFullYear(), 0, 1)
    weekNo = Math.ceil(( ( (d - yearStart) / 86400000) + 1) / 7)
    return if weekNo % 2 == 0 then 'even' else 'odd'

  getCurrentDow: ->
    ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][@props.date.getDay()]

  getDefaultProps: ->
    date: new Date()
    timing: {}
    sched: {}

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
    (div {id: 'schedule', className: @viewType}, [
      (blocks.map (block)->
        self.transferPropsTo(SchedBlock {dows: block, curr: curr})
      )
    ])
