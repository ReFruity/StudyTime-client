{span, div, h3, input, a, i} = React.DOM
{classSet} = React.addons

##
# Header of any view
#
SelectorHeader = React.createClass
  propTypes:
    headerText: React.PropTypes.string.isRequired
    prevHandler: React.PropTypes.func.isRequired
    nextHandler: React.PropTypes.func.isRequired
    prevView: React.PropTypes.func

  render: ->
    (div {className: 'header'}, [
      (a {onClick: @props.prevHandler},
        (i {className: 'stico-arrow-right rotate-180'})
      )
      (h3 {className: 'switch', onClick: @props.prevView},
        (a {}, @props.headerText)
      )
      (a {onClick: @props.nextHandler},
        (i {className: 'stico-arrow-right'})
      )
    ])


##
# Abstract selector class
#
SelectorMixin = {
  propTypes:
    prevView: React.PropTypes.func
    nextView: React.PropTypes.func.isRequired
    value: React.PropTypes.instanceOf(Date).isRequired
    after: React.PropTypes.instanceOf(Date)
    before: React.PropTypes.instanceOf(Date)

  getInitialState: ->
    current: new Date(@props.value)

  switchCurrentDate: (delta) ->
    newDate = new Date(@state.current)
    @setDeltaValue(newDate, delta)
    @setState current: newDate

  componentWillReceiveProps: (props)->
    @setState current: props.value

  onPrev: ->
    @switchCurrentDate(@selectorDelta*-1)

  onNext: ->
    @switchCurrentDate(@selectorDelta)

  isCurrentValue: (date)->
    iss = true
    now = @props.value
    `switch (this.view) {
      case 'minutes':
        iss &= ~~(date.getMinutes()/5) === ~~(now.getMinutes()/5);
      case 'hours':
        iss &= date.getHours() === now.getHours();
      case 'date':
        iss &= date.getDate() === now.getDate();
      case 'month':
        iss &= date.getMonth() === now.getMonth();
      case 'year':
        iss &= date.getFullYear() === now.getFullYear();
    }`
    iss

  isBefore: (date)->
    if @props.after and date.getTime() <= @props.after.getTime() then yes else no

  isAfter: (date)->
    if @props.before and date.getTime() >= @props.before.getTime() then yes else no

  render: ->
    visible = @getVisibleValues()
    self = @
    (div {}, [
      (SelectorHeader {
        headerText: @getHeader(visible)
        prevHandler: @onPrev
        nextHandler: @onNext
        prevView: (->try self.props.prevView(self.state.current))
      })
      (@getColumnNames(visible) if @getColumnNames)
      (div {className: 'values'},
        visible.map (val) ->
          (a {
            className: classSet('current': self.isCurrentValue(val), 'before': self.isBefore(val), 'after': self.isAfter(val))
            onClick: (->self.props.nextView(val) unless self.isBefore(val) or self.isAfter(val))
          }, self.getCellValue(val))
      )
    ])
}

##
# Year selection view
#
YearSelector = React.createClass
  mixins: [SelectorMixin]
  selectorDelta: 10
  view: 'year'

  setDeltaValue: (date, delta)->
    date.setFullYear(date.getFullYear() + delta)

  getHeader: (v)->
    "#{v[0].getFullYear()}-#{v[v.length-1].getFullYear()}"

  getCellValue: (v)->
    v.getFullYear()

  getVisibleValues: ->
    years = []
    date = new Date(@state.current)
    date.setFullYear(date.getFullYear() - (date.getFullYear() % 10))
    for ii in [0...12]
      nextDate = new Date(date)
      nextDate.setFullYear(date.getFullYear() + (ii - 1))
      years.push(nextDate)
    years


##
# Month selection view
#
MonthSelector = React.createClass
  mixins: [SelectorMixin]
  selectorDelta: 1
  view: 'month'

  setDeltaValue: (date, delta)->
    date.setFullYear(date.getFullYear() + delta)

  getHeader: ->
    @state.current.getFullYear()+""

  getCellValue: (v)->
    getFormattedDate(v, 'MMM')

  getVisibleValues: ->
    date = new Date(@state.current)
    months = []
    for ii in [0...12]
      nextDate = new Date(date)
      nextDate.setMonth(ii)
      months.push(nextDate)
    months


##
# Date of month selector
#
DateSelector = React.createClass
  mixins: [SelectorMixin]
  selectorDelta: 1
  view: 'date'

  setDeltaValue: (date, delta)->
    date.setMonth(date.getMonth() + delta)

  getHeader: ->
    getFormattedDate(@state.current, 'yyyy, MMM')

  getCellValue: (v)->
    v.getDate()

  getColumnNames: (values)->
    (div {className: 'dow-names'},
      values.slice(0,7).map (v)->
        (span {}, getFormattedDate(v, 'EEE'))
    )

  getVisibleValues: ->
    date = new Date(@state.current)
    date.setDate(1)
    if date.getDay() == 0
      date.setDate(-5)
    else
      date.setDate(date.getDate() - (date.getDay() - 1))

    days = [];
    while days.length < 29
      for ii in [0...7]
        days.push(new Date(date))
        date.setDate(date.getDate() + 1)
    days


##
# Hours selection view
#
HoursSelector = React.createClass
  mixins: [SelectorMixin]
  selectorDelta: 24
  view: 'hours'

  setDeltaValue: (date, delta)->
    date.setHours(date.getHours() + delta)

  getHeader: ->
    getFormattedDate(@state.current, 'dd MMMM yyyy')

  getCellValue: (v)->
    v.getHours()+':00'

  getVisibleValues: ->
    date = new Date(@state.current)
    date.setHours(0)
    date.setMinutes(0)
    date.setSeconds(0)
    date.setMilliseconds(0)
    hours = []
    for ii in [0...24]
      hours.push(date)
      date = new Date(date.getTime() + 60 * 60 * 1000)
    hours


##
# Minutes selection
#
MinutesSelector = React.createClass
  mixins: [SelectorMixin]
  selectorDelta: 1
  view: 'minutes'

  setDeltaValue: (date, delta)->
    date.setHours(date.getHours() + delta)

  getHeader: ->
    getFormattedDate(@state.current, 'dd MMMM yyyy')

  getCellValue: (v)->
    getFormattedDate(v, 'HH:mm')

  getVisibleValues: ->
    date = new Date(@state.current)
    date = new Date(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours())
    minutes = []
    stop = date.getTime() + 60 * 60 * 1000
    while date.getTime() < stop
      minutes.push(date)
      date = new Date(date.getTime() + 5 * 60 * 1000)
    minutes


##
# Main date picker component
#
module.exports = React.createClass
  propTypes:
    minView: React.PropTypes.string
    maxView: React.PropTypes.string
    view: React.PropTypes.string
    value: React.PropTypes.object
    after: React.PropTypes.instanceOf(Date)
    before: React.PropTypes.instanceOf(Date)

  viewOrders:
    year: 0
    month: 1
    date: 2
    hours: 3
    minutes: 4

  getDefaultProps: ->
    minView: 'year'
    maxView: 'minutes'
    view: 'date'
    value: new Date()

  getInitialState: ->
    value: (new Date(@props.value) if @props.value)
    view: @props.view
    showed: no

  componentWillReceiveProps: (props)->
    @setState value: (new Date(props.value) if props.value)

  maybeNextView: (newView, oldView)->
    if @viewOrders[newView] <= @viewOrders[@props.maxView] then newView else oldView

  maybePrevView: (newView, oldView)->
    if @viewOrders[newView] >= @viewOrders[@props.minView] then newView else oldView

  onNextView: (date) ->
    @props.onChange(date)
    switch @state.view
      when 'year' then @setState view: @maybeNextView('month', 'year'), value: date
      when 'month' then @setState view: @maybeNextView('date', 'month'), value: date
      when 'date' then @setState view: @maybeNextView('hours', 'date'), value: date
      when 'hours' then @setState view: @maybeNextView('minutes', 'hours'), value: date
      when 'minutes' then @setState value: date

  onPrevView: (date) ->
    switch @state.view
      when 'month' then @setState view: @maybePrevView('year', 'month'), value: date
      when 'date' then @setState view: @maybePrevView('month', 'date'), value: date
      when 'hours' then @setState view: @maybePrevView('date', 'hours'), value: date
      when 'minutes' then @setState view: @maybePrevView('hours', 'minutes'), value: date

  togglePicker: ->
    @setState showed: !@state.showed
    @props.onChange(@state.value)

  formattedDateValue: ->
    if @state.value
      getFormattedDate(@state.value, 'dd.MM.yyyy, HH:mm')
    else
      ''

  onManuallyChangeDate: (e)->
    e.preventDefault()

  render: ->
    (div {className: 'date-time-picker'}, [
      @transferPropsTo(input {onFocus: @togglePicker, onBlur: @togglePicker, onChange: @onManuallyChangeDate, value: @formattedDateValue()})
      (if @state.showed
        args = {nextView: @onNextView, prevView: @onPrevView, value: (if @state.value then @state.value else new Date())}
        (div {className: "#{@state.view}", onMouseDown: ((e)->e.preventDefault())}, (
          switch @state.view
            when 'year' then @transferPropsTo(YearSelector args)
            when 'month' then @transferPropsTo(MonthSelector args)
            when 'date' then @transferPropsTo(DateSelector args)
            when 'hours' then @transferPropsTo(HoursSelector args)
            when 'minutes' then @transferPropsTo(MinutesSelector args)
            else @transferPropsTo(YearSelector args)
        ))
      )
    ])