{span, div, table, tr, td, thead, tbody} = React.DOM


SelectorHeader = React.createClass
  render: ->
    (span {}, 'header')


YearSelector = React.createClass
  render: ->
    (span {}, 'header')

MonthSelector = React.createClass
  render: ->
    (span {}, 'header')

DateSelector = React.createClass
  render: ->
    (span {}, 'header')

HoursSelector = React.createClass
  render: ->
    (span {}, 'header')

MinutesSelector = React.createClass
  render: ->
    (span {}, 'header')

module.exports = React.createClass
  getDefaultProps: ->
    view: 'year'

  getInitState: ->
    view: @props.minView

  render: ->
    (div {className: 'date-time-picker'}, [
      (table {}, (
        switch @state.view
          when 'year' then @transferPropsTo(YearSelector {})
          when 'month' then @transferPropsTo(MonthSelector {})
          when 'date' then @transferPropsTo(DateSelector {})
          when 'hours' then @transferPropsTo(HoursSelector {})
          when 'minutes' then @transferPropsTo(MinutesSelector {})
          else @transferPropsTo(YearSelector {})
      ))
    ])