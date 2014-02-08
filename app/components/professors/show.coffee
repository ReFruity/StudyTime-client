React = require 'react'
{div, img, span, strong, table, tr, td, i, a} = React.DOM
nav = require '/components/schedule/parts/nav'
Professor = require 'models/professor'
MobileTitle = require '/components/helpers/mobileTitle'
BackButton =  require '/components/helpers/backButton'


#fake resource
resource =
  firstName: 'Александр',
  secondName: 'Промах',
  middleName: 'Иванович',
  image: 'http://www.vokrugsveta.ru/img/ann/news/main/2009/09/11/7391.jpg',
  address: 'Тургенева 4, ауд. 628',
  email: 's-promakh@ya.ru',
  phone: '+7-123-45-67-890'

module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    resource: resource
#    resource: new Professor(id: @props.route.id).fetchThis
#      success: @forceUpdate.bind(@, null)

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
    imageUrl = if !!resource.image then resource.image else '/images/professor-no-image.png'

    div {className: 'professor'}, [
      div {className: 'container'}, [
        img src: imageUrl
      ]
      div {className: 'full-name-wrap'}, [
        div {className: 'container'}, [
          div {className: 'full-name'}, [
            strong {}, resource.secondName
            " #{resource.firstName} #{resource.middleName}"
          ]
        ]
      ]
      div {className: 'card'}, [
        div {className: 'container'}, [
          table {}, ['address', 'email', 'phone'].map (attribute) ->
            tr {}, [
              td {}, t("attributes.professor.#{attribute}")
              td {}, resource[attribute]
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

  render: ->
    div {className: 'professor-schedule container'}, [
      div {className: 'sched-nav'}, [
        nav.WeekSwitcher bounds: @state.bounds, switchWeekHandler: (->)
        nav.UpdateIndicator updated: true
        BackButton()
      ]
      PersonalSchedule()
    ]

##########

PersonalSchedule = React.createClass
  render: ->
    div {}, [
      div {className: 'day'}, [
        div {className: 'circle'}
        div {className: 'content'}, [
          div {className: 'header'}, [
            div {className: 'day-of-week'}, 'Понедельник'
            div {className: 'date'}, '18 фев'
          ]
          div {className: 'events'}, [
            div {className: 'event'}, [
              div {className: 'time'}, '9:00 - 10:30'
              div {className: 'subject'}, 'Математический анализ'
              div {className: 'address'}, 'Тургенева 4,'
              div {className: 'room'}, '632'
            ]
          ]
          div {className: 'events'}, [
            div {className: 'event'}, [
              div {className: 'time'}, '9:00 - 10:30'
              div {className: 'subject'}, 'Математический анализ'
              div {className: 'address'}, 'Тургенева 4,'
              div {className: 'room'}, '632'
            ]
          ]
        ]
      ]
      div {className: 'day current'}, [
        div {className: 'circle'}
        div {className: 'content'}, [
          div {className: 'header'}, [
            div {className: 'day-of-week'}, 'Понедельник'
            div {className: 'date'}, '18 фев'
          ]
          div {className: 'events'}, [
            div {className: 'event current'}, [
              div {className: 'time'}, '9:00 - 10:30'
              div {className: 'subject'}, 'Математический анализ'
              div {className: 'address'}, 'Тургенева 4,'
              div {className: 'room'}, '632'
            ]
          ]
        ]
      ]
    ]



