React = require 'react'
{span, div} = React.DOM

PlacesSchedule = require '/models/placesSchedule'
ScheduleView = require 'components/schedule/parts/schedule'

PlacesCell = React.createClass
  render: ->
    span {}, 'hello'

##########

PlacesDetails = React.createClass
  render: ->
    span {}, 'hello'

##########

module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    bounds: new Date().getWeekBounds()
    placesSchedule: new PlacesSchedule(faculty: @props.route.faculty).fetchThis
      success: @forceUpdate.bind(@, null)

  render: ->
    console.log(@state.placesSchedule)

    div {id: 'places-index', className: 'container'}, [
      if @state.placesSchedule.timing() is undefined
        span {}, t('messages.loading')
      else
        ScheduleView(
  #        weekDate: @state.bounds[0]
          cellElem: PlacesCell
          detailsElem: PlacesDetails
  #        sched: @state.placesSchedule.get('schedule') or {}
          timing: @state.placesSchedule.timing() or {}
#          details: true
#          details: (
#            try
#              if @state.placesSchedule.get("schedule")[route.dow][route.number][route.atom]
#                dow: route.dow
#                number: route.number
#                data: @state.placesSchedule.get("schedule")[route.dow][route.number][route.atom]
#            catch e
#              undefined
#          )
        )
    ]