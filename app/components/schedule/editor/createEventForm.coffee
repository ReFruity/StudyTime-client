React = require 'react'
_ = require 'underscore'
{span, div, a, ul, li, i, form, input, label, select, option, textarea, button, h3} = React.DOM
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
    @focusOnSubject()
    @setState _.assign(@state, (props.state or {}))

  setSubject: (e)->
    @setState
      subject: (if e.target then {name: e.target.value} else e)

  setProfessor: (prof)->
    @setState professor: prof

  setPlace: (place) ->
    @setState place: place

  setEventType: (e)->
    if e.target.value
      @setState type: e.target.value

  setHalfGroup: (e)->
    if e.target.value
      @setState half_group: parseInt(e.target.value)

  setParity: (e)->
    if e.target.value
      @setState parity: parseInt(e.target.value)

  onSwitchLength: (item)->
    @setState infinity: item.value

  onSubmitForm: (e)->
    e.preventDefault()
    @props.submitHandler(_.clone(@state))

  focusOnSubject: ->
    self = @
    setTimeout(->
      self.refs['subjectInput'].getDOMNode().focus()
    , 300)

  render: ->
    (div {className: 'cr-event'}, [
      (form {onSubmit: @onSubmitForm, role: 'form'}, [
        (div {className: 'row'}, [
          # Form column
          (div {className: 'col-xs-6 form-group'}, [
            (div {className: 'row'}, [
              (div {className: 'col-xs-12 form-group'}, [
                (label {className: classSet('sr-only': not @state.subject.name.length), htmlFor: 'subjectInput'}, 'Предмет')
                (input {ref: 'subjectInput', id: 'subjectInput', className: 'form-control', placeholder: 'Предмет', value: @state.subject.name, onChange: @setSubject})
                (suggestions {inputId: 'subjectInput', value: @state.subject.name, selectItemHandler: @setSubject, model: 'subject'})
              ])
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-12 form-group'}, [
                (label {className: classSet('sr-only': not @state.professor.length), htmlFor: 'proffInput'}, 'Преподаватель')
                (taggedInput {id: 'proffInput', suggestions: 'professor', className: 'form-control', allowSpace: yes, placeholder: 'Преподаватель', value: @state.professor, onChange: @setProfessor})
              ])
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-6 form-group'}, [
                (label {className: classSet('sr-only': not @state.place.length), htmlFor: 'placeInput'}, 'Аудитория')
                (taggedInput {id: 'placeInput', suggestions: 'place', className: 'form-control', placeholder: 'Аудитория', value: @state.place, onChange: @setPlace})
              ])
              (div {className: 'col-xs-6 form-group'}, [
                (label {className: classSet('sr-only': not @state.type), htmlFor: 'typeInput'}, 'Тип события')
                (select {id: 'typeInput', className: 'form-control', value: @state.type, onChange: @setEventType}, [
                  (option {value: '', disabled:'disabled'}, '– Тип события –')
                  (@props.eventTypes.map (type) ->
                    (option {value: type}, t("schedule.event.types.#{type}"))
                  )
                ])
              ])
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-6 form-group'}, [
                (label {className: classSet('sr-only': !(@state.half_group >= 0)), htmlFor: 'hgInput'}, 'Часть группы')
                (select {id: 'hgInput', className: 'form-control', value: @state.half_group, onChange: @setHalfGroup}, [
                  (option {value: '', disabled:'disabled'}, '– Часть группы –')
                  (option {value: 0}, t("schedule.event.hg.0"))
                  (option {value: 1}, t("schedule.event.hg.1"))
                  (option {value: 2}, t("schedule.event.hg.2"))
                ])
              ])
              (div {className: 'col-xs-6 form-group'}, [
                (label {className: classSet('sr-only': !(@state.parity >= 0)), htmlFor: 'parityInput'}, 'Период')
                (select {id: 'parityInput', className: 'form-control', value: @state.parity, onChange: @setParity}, [
                  (option {value: '', disabled:'disabled'}, '– Период –')
                  (option {value: 0}, t("schedule.event.parity.0"))
                  (option {value: 1}, t("schedule.event.parity.1"))
                  (option {value: 2}, t("schedule.event.parity.2"))
                ])
              ])
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-12 form-group'},
                (switcher {
                  values: [
                    {name: 'Весь семестр', value: yes}
                    {name: getFormattedDate(@state.activity_start, 'Только dd MMMM'), value: no} if @state.activity_start
                  ]
                  value: @state.infinity
                  onChange: @onSwitchLength
                })
              )
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-12 form-group'},
                (button {className: 'btn btn-success form-control'}, 'Готово')
              )
            ])
          ])

          # Preview column
          (div {className: 'col-xs-6 form-group preview'}, [
            (eventPreview {state: @state})
          ])
        ])
      ])
    ])