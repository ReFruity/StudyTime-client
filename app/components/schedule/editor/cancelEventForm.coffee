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

  getInitialState: ->
    _.assign({
      modifyType: 0
      cancelType: 1
      cancelCount: 1
      activity_start: new Date()
    }, (@props.state or {}))

  componentWillReceiveProps: (props) ->
    @setState _.assign(@state, (props.state or {}))

  setCancelStartDate: (date) ->
    @setState activity_start: date

  setCancelCount: (e)->
  	if e.target.value
  		value = @state.cancelCount
  		if not _.isNaN(parseInt(e.target.value))
  			value = parseInt(e.target.value)
  		if value >= 1 and value < 500
  			@setState
          cancelCount: value
          _enterCancelCountError: no
  	else
  		@setState cancelCount: ''

  setDescription: (e)->
    @setState description: e.target.value

  onSwitchCancelType: (e)->
    @setState
      cancelType: parseInt(e.target.value)
      cancelCount: if e.target.value == '1' then 1 else @state.cancelCount

  onSubmitForm: (e)->
    e.preventDefault()
    if @state.cancelCount > 0
      @props.submitHandler(_.clone(@state))
    else
      @setState _enterCancelCountError: yes

  render: ->
    div {className: 'cr-event'}, [
      form {onSubmit: @onSubmitForm, role: 'form'}, [
        div {className: 'row'}, [
          div {className: 'col-xs-7 form-group'}, [
            div {className: 'row'}, [
              div {className: 'col-xs-6 form-group'}, [
                label {className: classSet('sr-only': not @state.cancelType), htmlFor: 'canTypeInput'}, 'Тип отмены'
                select {id: 'canTypeInput', className: 'form-control', value: @state.cancelType, onChange: @onSwitchCancelType}, [
                  option {value: '', disabled:'disabled'}, '– Тип отмены –'
                  option {value: 1}, 'Однократная отмена'
                  option {value: 2}, 'Отмена на несколько недель'
                  option {value: 3}, 'Полная отмена'
                ]
              ]
              div {className: 'col-xs-6 form-group'}, [
              	label {className: classSet('sr-only': not @state.activity_start), htmlFor: 'actStart'}, 'Дата первой отмены'
                dateTimePicker {id: 'actStart', className: 'form-control', maxView: 'date', format: 'dd.MM.yyyy', value: @state.activity_start, onChange: @setCancelStartDate}
              ]
            ]
            if @state.cancelType == 2
              div {className: 'row'}, [
                div {className: classSet('col-xs-6 form-group': yes, 'has-error': @state._enterCancelCountError)}, [
                  label {className: classSet('sr-only': not @state.cancelCount), htmlFor: 'cnacelCountInput'}, 'Кол-во недель'
                  input {id: 'cnacelCountInput', placeholder: 'Кол-во недель', className: 'form-control',value: @state.cancelCount, onChange: @setCancelCount}
                ]
              ]
            div {className: 'row'}, [
              div {className: 'col-xs-12 form-group'}, [
              	label {className: classSet('sr-only': not @state.description), htmlFor: 'descr'}, 'Комментарий'
                textarea {id: 'descr', placeholder: 'Комментарий', className: 'form-control',value: @state.description, onChange: @setDescription}
              ]
            ]
            div {className: 'row'}, [
              div {className: 'col-xs-12 form-group'}, [
                button {className: 'btn btn-success form-control'}, 'Все верно, отменить!'
              ]
            ]
          ]

          # Preview column
          div {className: 'col-xs-5 form-group preview'}, [
            eventPreview {state: @state}
          ]
        ]
      ]
    ]