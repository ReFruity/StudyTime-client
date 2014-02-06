React = require 'react'
{span, div, a, p, button, h4} = React.DOM
{studies, exams, vacation} = require '/components/schedule', 'studies', 'exams', 'vacation'
{modelMixin} = require '/components/common', 'modelMixin'
{Group} = require '/models', 'Group'

##
# Component for manipulating with group star and their proxies
#
GroupStar = React.createClass
  propTypes:
    group: React.PropTypes.object.isRequired

  getDefaultProps: ->
    group: {}

  render: ->
    div {className: 'group-star'},
      div {className: 'container'},
        div {className: 'row'}, [
          h4 {}, 'староста'
          a {className: 'main-staff'}
          a {className: 'supp-staff'}
          a {className: 'supp-staff'}
          a {className: 'btn btn-success'}, 'Добавить заместителя'
        ]



NoStaff = React.createClass
  render: ->
    div {className: 'no-staff'},
      div {className: 'container'},
        p {dangerouslySetInnerHTML: __html: t('schedule.texts.no_staff')}
          div {}, [
            button {className: 'btn btn-success'}, 'Я староста'
            button {className: 'btn btn-success'}, 'Пригласить старосту'
          ]


##
# Main group schedule component. Contains group schedule
# of some type ('studies' by default) and group star info
# It also binds group model for getting group information.
# (group star and so on)
#
module.exports = React.createClass
  mixins: [modelMixin]
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    group: new Group(name: @props.route.group).fetchThis()

  getBackboneModels: ->
    [@state.group]

  render: ->
    div {className: 'group-sched'}, [
      NoStaff {}
      if @state.group.get('name')
        switch @props.route.scheduleType
          when 'studies' then @transferPropsTo(studies {group: @state.group})
          when 'exams' then @transferPropsTo(exams {group: @state.group})
          when 'vacation' then @transferPropsTo(vacation {group: @state.group})
          else @transferPropsTo(studies {group: @state.group})

      GroupStar {group: @state.group}
    ]