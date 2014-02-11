_ = require 'underscore'
React = require 'react'
{classSet} = React.addons
{div, img, span, strong, table, tr, td, i, a} = React.DOM
nav = require '/components/schedule/parts/nav'
Professor = require 'models/professor'
Events = require 'collections/events'
MobileTitle = require '/components/helpers/mobileTitle'
BackButton = require '/components/helpers/backButton'
DateFormat = require '/components/common/dateFormat'


module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    resource: new Professor(id: @props.route.id).fetchThis
      success: @forceUpdate.bind(@, null)

  render: ->
    div {id: 'professors-show'}, [
      MobileTitle title: 'Преподаватель'
      ProfessorCard resource: @state.resource
      ProfessorSchedule resource: @state.resource
    ]

##########

ProfessorCard = React.createClass
  propTypes:
    resource: React.PropTypes.object.isRequired

  render: ->
    {resource} = @props

    div {className: 'professor'}, [
      div {className: 'container'}, [
        img src: resource.imageUrl()
      ]
      div {className: 'full-name-wrap'}, [
        div {className: 'container'}, [
          div {className: 'full-name'},
            if resource.fetchActive
              [t('messages.loading')]
            else
              [
                strong {}, resource.secondName()
                " #{resource.firstName()} #{resource.middleName()}"
              ]
        ]
      ]
      div {className: 'card'}, [
        div {className: 'container'}, [
          table {}, ['address', 'email', 'phone'].map (attribute) ->
            tr {}, [
              td {}, t("attributes.professor.#{attribute}")
              td {}, resource[attribute]()
            ]
        ]
      ]
    ]

##########

ProfessorSchedule = React.createClass
  propTypes:
    resource: React.PropTypes.object.isRequired

  getInitialState: ->
    bounds: new Date().getWeekBounds()
    events: new Events().fetchThis
      data:
        professor: @props.resource.id
      success: @forceUpdate.bind(@, null)

  updateBounds: (bounds) ->
    @setState
      bounds: bounds

  render: ->
    div {className: 'professor-schedule container'}, [
      div {className: 'sched-nav'}, [
        nav.WeekSwitcher bounds: @state.bounds, switchWeekHandler: @updateBounds
        nav.UpdateIndicator updated: true
        BackButton()
      ]
      PersonalSchedule events: @state.events, bounds: @state.bounds
    ]

##########

PersonalSchedule = React.createClass
  propTypes:
    events: React.PropTypes.object.isRequired
    bounds: React.PropTypes.array.isRequired

  render: ->
    schedule = {}
    #    @props.events.each (event) ->
    _.each @props.events.byBounds(@props.bounds), (event) ->
      day = event.getStart().getDay()
      schedule[day] ||= []
      schedule[day].push event
    if schedule[0]
      schedule[7] = schedule[0]
      delete schedule[0]

    if _.isEqual schedule, {}
      return span {}, t('messages.schedule_is_blank')

    div {}, (_.map _.keys(schedule).sort(), (dayOfWeek) =>
      div {className: classSet(day: true, current: new Date().getDay().toString() is dayOfWeek)}, [
        div {className: 'circle'}
        div {className: 'content'}, [
          div {className: 'header'}, [
            DateFormat {className: 'day-of-week', date: schedule[dayOfWeek][0].getStart(), format: "EEEE"}
            DateFormat {className: 'date', date: @getWeekDate(dayOfWeek), format: "dd MMM"}
          ]
          div {className: 'events'}, _.map(schedule[dayOfWeek].sort(@byHours), (event) ->
            div {className: 'event'}, [
              div {className: 'time'}, [
                DateFormat {date: event.getStart(), format: "HH:mm"}
                ' - '
                DateFormat {date: event.getEnd(), format: "HH:mm"}
              ]
              div {className: 'subject'}, event.subjectName()
#              div {className: 'address'}, 'Тургенева 4,'
              div {className: 'room'}, event.rooms()
            ]
          )
        ]
      ]
    )

  byHours: (a, b) ->
    a.getStart().getHours() - b.getStart().getHours()

# в bounds[0] должен быть понедельник
  getWeekDate: (dayOfWeek) ->
    now = new Date(@props.bounds[0])
    new Date now.setDate(now.getDate() + parseInt(dayOfWeek) - 1)