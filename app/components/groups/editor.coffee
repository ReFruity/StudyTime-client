React = require 'react'
_ = require 'underscore'
{span, div, h2, h3, a, button, p, form, label, input} = React.DOM
BackButton =  require '/components/helpers/backButton'
{i18n, dateTimePicker, taggedInput, dateFormat, switcher, suggestions} = require '/components/common', 'i18n', 'dateTimePicker', 'taggedInput', 'dateFormat', 'switcher', 'suggestions'

module.exports = React.createClass
  getInitialState: ->
    timing: {'1': {},'2': {},'3': {},'4': {},'5': {},'6': {},'7': {}}
    spec: [
      {name: 'КН', full_name: 'Компьютерные науки', groups: [{number: '101', course: 1}]}
      {name: 'МТ', full_name: 'Математика', groups: [{number: '101', course: 1}]}
      {name: 'МХ', full_name: 'Маханика', groups: [{number: '101', course: 1}]}
    ]

  onChangeStartTime: (clazzIdx, date)->
    timing = _.clone(@state.timing)
    timing[clazzIdx].start = date
    @setState timing: timing

  onChangeEndTime: (clazzIdx, date)->
    timing = _.clone(@state.timing)
    timing[clazzIdx].end = date
    @setState timing: timing

  onChangeSpeciality: (idx, spec)->
    specs = _.clone(@state.spec)
    specs[idx] = spec
    @setState spec: specs

  onAddSpeciality: (e)->
    e.preventDefault()
    specs = _.clone(@state.spec)
    specs.push {groups: [{}]}
    @setState spec: specs

  onChangeGroup: (specIdx, groupIdx, g)->
    specs = _.clone(@state.spec)
    specs[specIdx].groups[groupIdx] = g
    @setState spec: specs

  onAddGroup: (specIdx)->
    specs = _.clone(@state.spec)
    specs[specIdx].groups.push {}
    @setState spec: specs

  render: ->
    div {className: 'faculty-editor'},
      form {role: 'form'},
        RingScheduleEditor {timing: @state.timing, onChangeStartTime: @onChangeStartTime, onChangeEndTime: @onChangeEndTime}
        SpecialitiesEditor {spec: @state.spec, onChangeSpeciality: @onChangeSpeciality, onAddSpeciality: @onAddSpeciality}
        GroupsEditor {spec: @state.spec, onChangeGroup: @onChangeGroup, onAddGroup: @onAddGroup}
        DoneButton {}


DoneButton = React.createClass
  render: ->
    div {className: 'done-cont'},
      div {className: 'container'},
          div {className: 'row'},
            div {className: 'col-xs-12 form-group'},
              button {className:'btn btn-success btn-large', onClick: @props.onAddSpeciality}, 'Готово'



RingScheduleEditor = React.createClass
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
                dateTimePicker {onChange: ((date)->self.props.onChangeStartTime(cidx, date)), key: "classStart-#{cidx}", id: "classStart-#{cidx}", className: 'form-control time-period', view:'hours', minView: 'hours', maxView: 'minutes', value: self.props.timing[cidx].start, format: 'HH:mm'}
                span {}, ' – '
                dateTimePicker {onChange: ((date)->self.props.onChangeEndTime(cidx, date)), key: "classEnd-#{cidx}", id: "classEnd-#{cidx}", className: 'form-control time-period', view:'hours', minView: 'hours', maxView: 'minutes', value: self.props.timing[cidx].end, format: 'HH:mm'}


SpecialitiesEditor = React.createClass
  onChangeFullName: (idx, name)->
    spec = _.clone(@props.spec[idx])
    spec.full_name = name
    @props.onChangeSpeciality(idx, spec)

  onChangeShortName: (idx, name)->
    spec = _.clone(@props.spec[idx])
    spec.name = name.replace(' ', '')
    @props.onChangeSpeciality(idx, spec)

  render: ->
    self = @
    div {className: 'spec-editor'},
      div {className: 'container'},
        div {className: 'row'},
          h2 {}, 'Специальности'
          p {}, 'Добавьте все специальности своего факультета. Внимательно отнеситесь к краткому названию, оно будет подставлено к номеру каждой группы'
        _.map @props.spec, (s, idx)->
          div {className: 'row spec'},
            div {className: 'col-sm-4 col-xs-8 form-group'},
              label {}, 'Полное название' if idx == 0
              input {className: 'form-control', placeholder: 'Полное название', onChange: ((e)->self.onChangeFullName(idx, e.target.value)), value: s.full_name}
            div {className: 'col-sm-2 col-xs-3 form-group'},
              label {}, 'Сокращение' if idx == 0
              input {className: 'form-control', placeholder: 'Сокращение', onChange: ((e)->self.onChangeShortName(idx, e.target.value)), value: s.name}
            div {className: 'col-xs-1 form-group'},
              span {className: "arrow"}, 'удалить'
        div {className: 'row'},
          div {className: 'col-sm-4 col-xs-12 form-group'},
            button {className:'btn btn-success', onClick: @props.onAddSpeciality}, 'Добавить еще'




GroupsEditor = React.createClass
  onChangeNumber: (sidx, gidx, name)->
    group = _.clone(@props.spec[sidx].groups[gidx])
    group.number = name
    if name and parseInt(name[0])>0
      group.course = parseInt(name[0])
    @props.onChangeGroup(sidx, gidx, group)

  onChangeCourse: (sidx, gidx, name)->
    val = parseInt(name)
    group = _.clone(@props.spec[sidx].groups[gidx])
    if val > 0 and val < 7
      group.course = val
    else if not name
      group.course = ''
    @props.onChangeGroup(sidx, gidx, group)


  render: ->
    self = @
    div {className: 'groups-editor'},
      div {className: 'container'},
        div {className: 'row'},
          h2 {}, 'Группы'
          p {}, 'Для каждой специальности добавьте все известные вам группы'

        div {className: 'spce'},
          _.map @props.spec, (s, sidx)->
            if s.full_name then [
              h3 {}, s.full_name
              _.map s.groups, (g, gidx)->
                div {className: 'row spec'},
                  div {className: 'col-sm-4 col-xs-8 form-group'},
                    label {}, 'Номер группы' if gidx == 0
                    input {onChange: ((e)->self.onChangeNumber(sidx, gidx, e.target.value)), className: 'form-control', value: g.number, placeholder: 'Номер группы'}
                  div {className: 'col-sm-2 col-xs-4 form-group'},
                    label {}, 'Курс' if gidx == 0
                    input {onChange: ((e)->self.onChangeCourse(sidx, gidx, e.target.value)), className: 'form-control', value: g.course, placeholder: 'Курс'}
              div {className: 'row spec'},
                div {className: 'col-sm-4 col-xs-12 form-group'},
                  button {className:'btn btn-success', onClick: ((e)->e.preventDefault();self.props.onAddGroup(sidx))}, 'Добавить группу'
            ]





