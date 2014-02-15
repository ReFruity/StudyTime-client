React = require 'react'
_ = require 'underscore'
lightbox = require 'lightbox'
{span, div, h2, h3, a, button, p, i} = React.DOM
{backButton, mobileTitle} =  require '/components/helpers', 'backButton', 'mobileTitle'
{modelMixin, authorized, uploadInput} = require '/components/common', 'modelMixin', 'authorized', 'uploadInput'
{inviteLightbox} = require '/components/user', 'inviteLightbox'
Faculty = require '/models/faculty'
Groups = require '/collections/groups'

module.exports = React.createClass
  mixins: [modelMixin]

  getInitialState: ->
    faculty: new Faculty().fetchThis(prefill:yes, expires:no, data: {university: @props.route.uni, name: @props.route.faculty})
    groups: new Groups().fetchThis(prefill:yes, expires:no, success: @onGroupsLoaded, prefillSuccess: @onGroupsLoaded, data: {university: @props.route.uni, faculty: @props.route.faculty})
    loaded: no

  getBackboneModels: ->
    [@state.faculty, @state.groups]

  onGroupsLoaded: ->
    @state.loaded = yes
    @forceUpdate()

  render: ->
    div {className: 'faculty'},
      if not @state.loaded then [
        div {className: 'container'},
          div {className: 'row'},
            backButton {}
            span {className: 'loading'}, 'Загрузка...'
      ]
      else if @state.groups.models.length != 0 then [
        div {className: 'container'},
          InfoRow {faculty: @state.faculty, route: @props.route}
        NoGroups {faculty: @state.faculty}
      ]
      else [
        div {className: 'container'},
          InfoRow {faculty: @state.faculty, route: @props.route}
          GroupsRow {groups: @state.groups.models, route: @props.route}
          AdminsRow {faculty: @state.faculty, route: @props.route}
      ]


NoGroups = React.createClass
  render: ->
    div {className: 'no-groups'},
      SadNoGroupsRow {faculty: @props.faculty}
      PosibleThings {faculty: @props.faculty}


SadNoGroupsRow = React.createClass
  render: ->
    div {className: 'sad-text'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-12'},
            h2 {}, 'К сожалению факультет еще не подключен'
            p {}, 'Но у Вас есть возможность это исправить! Вы можете...'


PosibleThings = React.createClass
  render: ->
    div {className: 'container'},
      div {className: 'posible-things row'},
        ScheduleUploader {faculty: @props.faculty}
        AdminStarted {}
        InviteAdmin {}


ScheduleUploader = React.createClass
  getInitialState: ->
    uploadProgress: 0
    uploadState: 0

  onFileUpload: (file)->
    self = @
    file.progress (percents)->
      self.setState
        uploadState: 1
        uploadProgress: percents
    file.start().done ->
      self.setState
        uploadState: 2

  render: ->
    div {className: 'sched-uploader col-sm-4'},
      switch @state.uploadState
        when 1
          div {className: 'upld-progress'},
            span {}, @state.uploadProgress+'%'
        when 2
          div {className: 'upld-done'},
            div {className: 'wrap'},
              h3 {}, 'Расписание загружено!'
              p {}, 'Мы обработаем ваше расписание так скоро, как это возможно'

      i {className: 'stico-upload'}
      h3 {}, 'Загрзить расписание'
      p {}, 'Если у вас есть расписание факультета в формате Excel, PDF или DOC, мы можем подключить ваш факультет'
      div {className: 'upld-btn-wrap'},
        button {className: 'btn btn-success'}, 'Выбрать файл'
        if @props.faculty.has '_id'
          uploadInput {
            uploadFileHandler: @onFileUpload
            schedule: {uni: @props.faculty.get('university').name, faculty: @props.faculty.get('name')}
          }


AdminStarted = React.createClass
  render: ->
    div {className: 'admin-starter col-sm-4'},
      i {className: 'stico-admin'}
      h3 {}, 'Стать администратором'
      p {}, 'Став администратором факультета, вам придется заполнить некоторую информацию о факультете, после чего вы сможете заполнить расписание самостоятельно.'
      button {className: 'btn btn-success'}, 'Стать администратором'

InviteAdmin = React.createClass
  showInviteLightbox: ->
    lightbox inviteLightbox

  render: ->
    div {className: 'invinte-admin col-sm-4'},
      i {className: 'stico-invite'}
      h3 {}, 'Пригласить администратора'
      p {}, 'Если вы не хотите заниматься администрированаем факультета, но знаете как связаться с тем, кто хотел бы этим заняться, то кнопка ниже для Вас'
      button {className: 'btn btn-success', onClick: @showInviteLightbox}, 'Пригласить администратора'

InfoRow = React.createClass
  render: ->
    div {className: 'info row'},
      h2 {},
        backButton {}
        span {className: 'faculty'}, @props.faculty.get('name') or @props.route.faculty
        span {className:'uni'}, if @props.faculty.has 'university' then @props.faculty.get('university').name+',' else ''
        span {className:'full-name'}, @props.faculty.get('full_name')
      mobileTitle {title: @props.faculty.get('name') or @props.route.faculty}


GroupsRow = React.createClass
  render: ->
    # Separate by speciality and course
    specs = {}
    for g in @props.groups
      g = g.attributes
      specs[g.speciality.name] = {} if not specs[g.speciality.name]
      specs[g.speciality.name][g.course] = [] if not specs[g.speciality.name][g.course]
      specs[g.speciality.name][g.course].push g

    # Create rows with cpeciality blocks
    specNames = _.keys(specs)
    specsRows = []
    for sidx in [0...specNames.length] by 4
      rowChildren = []
      specsRows.push div {className: 'row'}, rowChildren
      for gidx in [sidx...Math.min(sidx+4, specNames.length)]
        rowChildren.push SpecialityBlock {groups: specs[specNames[gidx]], name: specNames[gidx], route: @props.route}

    # Render result
    div {className: 'groups row'},
      div {className: 'container'}, specsRows


SpecialityBlock = React.createClass
  render: ->
    {route, name} = @props
    div {className: 'col-sm-3 speciality'},
      h3 {}, name
      div {className: 'spec-groups'},
        _.map @props.groups, (course)->
          div {className: 'course'},
            _.map course, (g)->
              a {href: "/#{route.uni}/#{route.faculty}/#{name}-#{g.name}"}, g.name
            div {className: 'clearfix'}


AdminsRow = React.createClass
  render: ->
    div {className: 'container admins'},
      h3 {}, 'администрация'
      div {className: 'photos'},
        span {className: 'small-photo'}
        span {className: 'small-photo'}
        span {className: 'small-photo'}
      div {className: 'add-admin-btn'},
        button {className: 'btn btn-success'}, 'Добавить админа'



