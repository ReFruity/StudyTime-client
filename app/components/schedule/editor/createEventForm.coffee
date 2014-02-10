React = require 'react'
_ = require 'underscore'
{span, div, a, ul, li, i, form, input, label, select, option, textarea, button, h3, p} = React.DOM
{i18n, dateTimePicker, taggedInput, dateFormat, switcher, suggestions} = require '/components/common', 'i18n', 'dateTimePicker', 'taggedInput', 'dateFormat', 'switcher', 'suggestions'
{eventPreview} = require '/components/schedule/editor', 'eventPreview'
{classSet} = React.addons

##
# Show a form for creating/changing event (or replacement)
# On submit it invoke handler, that can creates new event
# by given state of this component.
#
module.exports = React.createClass
  propTypes:
    state: React.PropTypes.object
    timing: React.PropTypes.object
    submitHandler: React.PropTypes.func.isRequired
    switchEditorHandler: React.PropTypes.func
    eventTypes: React.PropTypes.array

  getDefaultProps: ->
    eventTypes: ['lecture', 'practice', 'exam', 'test', 'consult']

  getInitialState: ->
    _.assign({
      infinity: yes
      activity_start: new Date()
      subject: {name: ''}
      place: []
      professor: []
    }, (@props.state or {}))

  componentDidMount: ->
    @focusOnSubject()

  componentWillReceiveProps: (props) ->
    @setState _.assign(@state, (props.state or {}))

  setSubject: (e)->
    if (e.target and e.target.value.length <=10) or not e.target
      @setState
        subject: (if e.target then {name: e.target.value} else e)
        _enterSubjError: no

  setProfessor: (prof)->
    @setState professor: prof

  setPlace: (place) ->
    @setState place: place

  setEventType: (e)->
    if e.target.value
      @setState
        type: e.target.value
        _enterTypeError: no

  setHalfGroup: (e)->
    if e.target.value
      @setState half_group: parseInt(e.target.value)

  setParity: (e)->
    if e.target.value
      @setState parity: parseInt(e.target.value)

  setActivityStart: (item)->
    @setState activity_start: item if item

  setTimeStart: (item)->
    if item
      @setState
        _time_start: item
        _enterTimeStartError: no
        activity_start: (
          new_act = new Date(@state.activity_start)
          new_act.setHours(item.getHours(), item.getMinutes())
          new_act
        )

  setTimeEnd: (item)->
    if item
      @setState
        _time_end: item
        _enterTimeEndError: no
        activity_end: (
          new_act = new Date(@state.activity_end or @state.activity_start)
          new_act.setHours(item.getHours(), item.getMinutes())
          new_act
        )

  onSubmitForm: (e)->
    e.preventDefault()
    if @state.subject and @state.subject.name and @state.type
      @props.submitHandler(_.clone(@state))
    else

    @setState
      _enterSubjError: (
        if not @state.subject or not @state.subject.name
          @focusOnSubject()
          yes
        else
          no
      )
      _enterTypeError: not @state.type
      _enterTimeEndError: not @state._time_end and @state.type not in ['lecture', 'practice']
      _enterTimeStartError: not @state._time_start and @state.type not in ['lecture', 'practice']

  focusOnSubject: ->
    self = @
    setTimeout(->
      self.refs['subjectInput'].getDOMNode().focus()
    , 300)

  render: ->
    div {className: 'cr-event'}, [
      form {onSubmit: @onSubmitForm, role: 'form'}, [
        div {className: 'row'}, [
          # Form column
          div {className: 'col-xs-7 form-group'}, [
            div {className: 'row'}, [
              div {className: classSet('col-xs-6 form-group':yes, 'has-error': @state._enterSubjError)}, [
                label {className: classSet('sr-only': not @state.subject.name.length), htmlFor: 'subjectInput'}, 'Предмет (макс. 10 символов)'
                input {ref: 'subjectInput', id: 'subjectInput', className: 'form-control', placeholder: 'Предмет (макс. 10 сим.)', value: @state.subject.name, onChange: @setSubject, require: yes}
                suggestions {inputId: 'subjectInput', value: @state.subject.name, selectItemHandler: @setSubject, model: 'subject'}
              ]
              div {className: classSet('col-xs-6 form-group':yes, 'has-error': @state._enterTypeError)}, [
                label {className: classSet('sr-only': not @state.type), htmlFor: 'typeInput'}, 'Тип события'
                select {id: 'typeInput', className: 'form-control', value: @state.type, onChange: @setEventType}, [
                  option {value: '', disabled:'disabled'}, '– Тип события –'
                  _.map @props.eventTypes, (type) ->
                    option {value: type}, t("schedule.event.types.#{type}")
                ]
              ]
            ]
            div {className: 'row'}, [
              div {className: 'col-xs-12 form-group'}, [
                label {className: classSet('sr-only': not @state.professor.length), htmlFor: 'proffInput'}, 'Преподаватель'
                taggedInput {id: 'proffInput', suggestions: 'professor', className: 'form-control', allowSpace: yes, placeholder: 'Преподаватель', value: @state.professor, onChange: @setProfessor}
              ]
            ]
            div {className: 'row'}, [
              div {className: 'col-xs-6 form-group'}, [
                label {className: classSet('sr-only': not @state.place.length), htmlFor: 'placeInput'}, 'Аудитория'
                taggedInput {id: 'placeInput', suggestions: 'place', className: 'form-control', placeholder: 'Аудитория', value: @state.place, onChange: @setPlace}
              ]
              div {className: 'col-xs-6 form-group'}, [
                label {className: classSet('sr-only': !(@state.half_group >= 0)), htmlFor: 'hgInput'}, 'Часть группы'
                select {id: 'hgInput', className: 'form-control', value: @state.half_group, onChange: @setHalfGroup}, [
                  option {value: '', disabled:'disabled'}, '– Часть группы –'
                  option {value: 0}, t("schedule.event.hg.0")
                  option {value: 1}, t("schedule.event.hg.1")
                  option {value: 2}, t("schedule.event.hg.2")
                ]
              ]
            ]
            if @state.type in ['lecture', 'practice']
              div {className: 'row'}, [
                div {className: 'col-xs-6 form-group'}, [
                  label {className: classSet('sr-only': !(@state.parity >= 0)), htmlFor: 'parityInput'}, 'Период'
                  select {id: 'parityInput', className: 'form-control', value: @state.parity, onChange: @setParity}, [
                    option {value: '', disabled:'disabled'}, '– Период –'
                    option {value: 0}, t("schedule.event.parity.0")
                    option {value: 1}, t("schedule.event.parity.1")
                    option {value: 2}, t("schedule.event.parity.2")
                    option {value: 3}, 'Один раз'
                  ]
                ]
                div {className: 'col-xs-6 form-group'}, [
                  label {className: classSet('sr-only': not @state.activity_start), htmlFor: 'actStart'}, 'Дата первой пары'
                  dateTimePicker {key: 'actStart', id: 'actStart', className: 'form-control', maxView: 'date', after: new Date(), format: 'dd.MM.yyyy', value: @state.activity_start, onChange: @setActivityStart}
                ]
              ]
            else if @state.type
              div {className: 'row'}, [
                div {className: 'col-xs-6 form-group'}, [
                  label {className: classSet('sr-only': not @state.activity_start), htmlFor: 'actStart'}, 'Дата'
                  dateTimePicker {key: 'actStart', id: 'actStart', className: 'form-control', maxView: 'date', after: new Date(), format: 'dd.MM.yyyy', value: @state.activity_start, onChange: @setActivityStart}
                ]
                div {className: classSet('col-xs-3 form-group':yes, 'has-error': @state._enterTimeStartError)}, [
                  label {className: classSet('sr-only': not @state._time_start), htmlFor: 'actTimeStart'}, 'Начало'
                  dateTimePicker {key: 'actTimeStart',id: 'actTimeStart', className: 'form-control', placeholder: 'Начало', minView: 'hours', view: 'hours', format: 'HH:mm', value: @state._time_start, onChange: @setTimeStart}
                ]
                div {className: classSet('col-xs-3 form-group':yes, 'has-error': @state._enterTimeEndError)}, [
                  label {className: classSet('sr-only': not @state._time_end), htmlFor: 'actTimeEnd'}, 'Конец'
                  dateTimePicker {key: 'actTimeEnd', id: 'actTimeEnd', className: 'form-control', placeholder: 'Конец', minView: 'hours', view: 'hours', after: @state._time_start, format: 'HH:mm', value: @state._time_end, onChange: @setTimeEnd}
                ]
              ]


            div {className: 'row'}, [
              div {className: 'col-xs-12 form-group'},
                button {className: 'btn btn-success form-control'}, 'Готово'
            ]
          ]

          # Preview column
          div {className: 'col-xs-5 form-group preview'}, [
            eventPreview {state: @state}
          ]
        ]
      ]
    ]