React = require 'react'
_ = require 'underscore'
{span, div, h2, h3, a, button, p} = React.DOM
BackButton =  require '/components/helpers/backButton'

module.exports = React.createClass
  getInitialState: ->
    faculty: {name: 'ИМКН', full_name: 'Институт математики и компьютерных наук', university: {name: 'УрФУ'}}
    groups: []

  render: ->
    div {className: 'groups'},
      div {className: 'container'}, [
        BackButton()
        if @state.groups.length == 0
          NoGroups {faculty: @state.faculty}
        else [
          InfoRow {faculty: @state.faculty}
          GroupsRow {groups: @state.groups}
          AdminsRow {faculty: @state.faculty}
        ]
      ]


NoGroups = React.createClass
  render: ->
    div {className: 'no-groups'},
      SadNoGroupsRow {faculty: @props.faculty}
      PosibleThings {faculty: @props.faculty}


SadNoGroupsRow = React.createClass
  render: ->
    div {className: 'sad-text row'},
      div {className: 'col-sm-12'},
        h2 {}, 'К сожалению, факультет еще не подключен'
        p {}, 'Но у Вас есть возможность наполнить свой факультет жизнью!'


PosibleThings = React.createClass
  render: ->
    div {className: 'posible-things row'},
      ScheduleUploader {}
      AdminStarted {}
      InviteAdmin {}


ScheduleUploader = React.createClass
  render: ->
    div {className: 'sched-uploader col-sm-4'},
      h3 {}, 'Загрзить расписание'
      p {}, 'Если у вас есть расписание факультета в формате Excel, PDF или DOC, мы можем подключить ваш факультет'
      button {className: 'btn btn-success'}, 'Выбрать файл'


AdminStarted = React.createClass
  render: ->
    div {className: 'admin-starter col-sm-4'},
      h3 {}, 'Стать администратором'
      p {}, 'Став администратором факультета, вам придется заполнить некоторую информацию о факультете, после чего вы сможете заполнить расписание самостоятельно.'
      button {className: 'btn btn-success'}, 'Стать администратором'

InviteAdmin = React.createClass
  render: ->
    div {className: 'invinte-admin col-sm-4'},
      h3 {}, 'Пригласить администратора'
      p {}, 'Если вы не хотите заниматься администрированаем факультета, но знаете как связаться с тем, кто хотел бы этим заняться, то кнопка ниже для Вас'
      button {className: 'btn btn-success'}, 'Пригласить администратора'

InfoRow = React.createClass
  render: ->
    div {className: 'info row'},
      h2 {},
        span {className:'name'}, @props.faculty.name
        span {className:'uni'}, @props.faculty.university.name
      h3 {}, @props.faculty.full_name


GroupsRow = React.createClass
  render: ->
    specs = []
    for sidx in [0...@props.groups.length] by 4
      rowChildren = []
      specs.push div {className: 'row'}, rowChildren
      for gidx in [sidx...Math.min(sidx+4, @props.groups.length)]
        rowChildren.push SpecialityBlock {speciality: @props.groups[gidx]}

    div {className: 'groups'},
      div {className: 'container'}, specs


SpecialityBlock = React.createClass
  render: ->
    div {className: 'col-sm-3 group'},
      h3 {}, @props.speciality.name
      _.map @props.speciality.groups, (course)->
        div {className: 'course'},
          _.map course, (g)->
            a {}, g


AdminsRow = React.createClass
  render: ->
    div {className: 'admins'},
      h3 {}, 'администрация'
      button {className: 'btn btn-success'}, 'Добавить администратора'



