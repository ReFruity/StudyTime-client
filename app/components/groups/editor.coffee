React = require 'react'
_ = require 'underscore'
{span, div, h2, h3, a, button, p, form, label} = React.DOM
BackButton =  require '/components/helpers/backButton'
{i18n, dateTimePicker, taggedInput, dateFormat, switcher, suggestions} = require '/components/common', 'i18n', 'dateTimePicker', 'taggedInput', 'dateFormat', 'switcher', 'suggestions'

module.exports = React.createClass
  render: ->
    div {className: 'faculty-editor'},
      form {role: 'form'},
        RingScheduleEditor {}
        SpecialitiesEditor {}
        GroupsEditor {}

RingScheduleEditor = React.createClass
  getDefaultProps: ->
    timing: {
      '1': {}
      '2': {}
      '3': {}
      '4': {}
      '5': {}
      '6': {}
      '7': {}
    }

  render: ->
    self = @
    div {className: 'ring-editor'},
      div {className: 'container'},
        div {className: 'row'},
          h2 {}, 'Расписание звонков'
          p {}, 'Заполните расписание звонков на своем факультете. Это поможет студентам факультета лучше ориентироваться в расписании'
        _.map _.keys(@props.timing), (cidx)->
          div {className: 'row'},
            div {className: 'class form-group'},
              label {htmlFor: "classStart-#{cidx}", className:'col-sm-1 control-label'}, "#{cidx} пара"
              div {className: 'col-sm-11'},
                dateTimePicker {key: "classStart-#{cidx}", id: "classStart-#{cidx}", className: 'form-control time-period', view:'hours', minView: 'hours', maxView: 'minutes', value: self.props.timing[cidx].start, format: 'HH:mm'}
                span {}, ' – '
                dateTimePicker {key: "classEnd-#{cidx}", id: "classEnd-#{cidx}", className: 'form-control time-period', view:'hours', minView: 'hours', maxView: 'minutes', value: self.props.timing[cidx].end, format: 'HH:mm'}




SpecialitiesEditor = React.createClass
  render: ->
    div {className: 'spec-editor'},
      div {className: 'container'},
        div {className: 'row'},
          h2 {}, 'Специальности'
          p {}, 'Добавьте все специальности своего факультета. Внимательно отнеситесь к краткому названию, оно будет подставлено к номеру каждой группы'
        div {className: 'row'},



GroupsEditor = React.createClass
  render: ->
    div {className: 'groups-editor'},
      div {className: 'container'},
        div {className: 'row'},
          h2 {}, 'Группы'
          p {}, 'Для каждой специальности добавьте все известные вам группы'