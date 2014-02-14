_ = require 'underscore'
React = require 'react'
{classSet} = React.addons
{div, img, span, strong, table, tr, td, i, a} = React.DOM
nav = require '/components/schedule/parts/nav'
Professor = require 'models/professor'
Events = require 'collections/events'
{mobileTitle, backButton} = require '/components/helpers', 'mobileTitle', 'backButton'
dateFormat = require '/components/common/dateFormat'
photo = require '/components/common/photo'

module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    loaded: false
    resource: new Professor(id: @props.route.id).fetchThis
      prefill: yes,
      expires: no
      prefillSuccess: @onLoad

  onLoad: ->
    @setState loaded: true

  render: ->
    div {id: 'professors-show'}, [
      mobileTitle title: 'Преподаватель'
      ProfessorCard resource: @state.resource, loaded: @state.loaded
      ProfessorSchedule resource: @state.resource
    ]

##########

ProfessorCard = React.createClass
  propTypes:
    resource: React.PropTypes.object.isRequired
    loaded: React.PropTypes.bool.isRequired

  render: ->
    {resource} = @props

    console.log(resource)

    div {className: 'professor'}, [
      div {className: 'container'}, [
        photo { id: resource.id, format: 'jpg', placeholder: 'professor-ph'} if resource.id
      ]
      div {className: 'full-name-wrap'}, [
        div {className: 'container'}, [
          div {className: 'full-name'},
            if @props.loaded
              [
                strong {}, resource.secondName()
                " #{resource.firstName()} #{resource.middleName()}"
              ]
            else
              [t('messages.loading')]
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
        backButton()
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
      div {className: classSet(day: true, current: @isCurrentDay(dayOfWeek))}, [
        div {className: 'circle'}
        div {className: 'content'}, [
          div {className: 'header'}, [
            dateFormat {className: 'day-of-week', date: schedule[dayOfWeek][0].getStart(), format: "EEEE"}
            dateFormat {className: 'date', date: @getWeekDate(dayOfWeek), format: "dd MMM"}
          ]
          div {className: 'events'}, _.map(schedule[dayOfWeek].sort(@byHours), (event) =>
            div {className: 'event'}, [
              if @isCurrentTime(event) then img {className: 'current-event', src: '/images/current-event.png'} else ''
              div {className: 'time'}, [
                dateFormat {date: event.getStart(), format: "HH:mm"}
                ' - '
                dateFormat {date: event.getEnd(), format: "HH:mm"}
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
    now = new Date @props.bounds[0]
    new Date now.setDate(now.getDate() + parseInt(dayOfWeek) - 1)

  isCurrentDay: (dayOfWeek) ->
    now = new Date()
    now.getDay() is parseInt(dayOfWeek) and @props.bounds[0].getTime() <= now.getTime() and now.getTime() <= @props.bounds[1]

  isCurrentTime: (event) ->
    now = @minutes new Date()
    start = @minutes event.getStart()
    end = @minutes event.getEnd()
    if start > end then  not (end <= now and now <= start) else start <= now and now <= end

  minutes: (date) ->
    date.getHours() * 60 + date.getMinutes()


