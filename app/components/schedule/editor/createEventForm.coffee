React = require 'react'
_ = require 'underscore'
{span, div, a, ul, li, i, form, input, label, select, option, textarea, button, h3} = React.DOM
{i18n, dateTimePicker, taggedInput, dateFormat, switcher, suggestions} = require '/components/common', 'i18n', 'dateTimePicker', 'taggedInput', 'dateFormat', 'switcher', 'suggestions'
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

  componentWillReceiveProps: (props) ->
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

  onSwitchLength: (item)->
    @setState infinity: item.value

  onSubmitForm: (e)->
    e.preventDefault()
    @props.submitHandler(_.clone(@state))

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
                (label {className: classSet('sr-only': not @state.professor.length), htmlFor: 'proffInput'}, 'Преподаватели')
                (taggedInput {id: 'proffInput', suggestions: 'professor', className: 'form-control', allowSpace: yes, placeholder: 'Преподаватели', value: @state.professor, onChange: @setProfessor})
              ])
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-12 form-group'}, [
                (label {className: classSet('sr-only': not @state.place.length), htmlFor: 'placeInput'}, 'Аудитория')
                (taggedInput {id: 'placeInput', suggestions: 'place', className: 'form-control', placeholder: 'Аудитория', value: @state.place, onChange: @setPlace})
              ])
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-6 form-group'}, [
                (label {className: classSet('sr-only': not @state.type), htmlFor: 'typeInput'}, 'Тип события')
                (select {id: 'typeInput', className: 'form-control', value: @state.type, onChange: @setEventType}, [
                  (option {value: ''}, '-- Тип события --')
                  (@props.eventTypes.map (type) ->
                    (option {value: type}, getLocalizedValue("schedule.event.types.#{type}"))
                  )
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
          ])

          # Preview column
          (div {className: 'col-xs-6 form-group preview'}, [
            ((div {className: 'row'},
              (div {className: 'col-xs-12'},
                (h3 {className: 'subject'}, @state.subject.name)
              )
            ) if @state.subject.name)
            (div {className: 'row enter-line'},
              (div {className: 'col-xs-12'},
                ((span {className: 'value single'},
                  (span {}, 'преподаватель ')
                  (@state.professor or []).map (prof, i) ->
                    (span {className:'value-itm'}, "#{if i > 0 then ', ' else ''}#{prof.name}")
                ) if @state.professor and @state.professor.length > 0)
                ((span {className: 'value'}, [
                  (span {}, 'в ')
                  (@state.place or []).map (place) ->
                    (span {className: 'value-itm'}, place.name+' ')
                  (span {}, 'аудитории')
                ]) if @state.place and @state.place.length > 0)
                ((span {className: 'value'}, [
                  (span {}, ', ')
                  (span {className: 'value-itm'}, getLocalizedValue("schedule.event.types.#{@state.type}"))
                ]) if @state.type)
              )
            )
            (div {className: 'row coord-line'}, [
              (div {className: 'col-xs-12'}, [

                ((span {className: 'value'}, [
                  (span {className:'value-itm'}, "#{@state.number} парой")
                ]) if @state.number)
                ((span {className: 'value'}, [
                  (span {}, ', ')
                  (switch @state.half_group
                    when 0 then (span {className: 'value-itm'}, 'у всей')
                    when 1 then (span {className: 'value-itm'}, 'у первой')
                    when 2 then (span {className: 'value-itm'}, 'у второй')
                  )
                  (switch @state.half_group
                    when 0 then (span {}, ' группы')
                    when 1,2 then (span {}, ' подгруппы')
                  )
                ]) if @state.half_group >= 0)
                ((span {className: 'value'}, [
                  (span {}, ', ')
                  (switch @state.parity
                    when 0 then (span {className:'value-itm'}, 'каждую')
                    when 1 then (span {className:'value-itm'}, 'по нечетным')
                    when 2 then (span {className:'value-itm'}, 'по четным')
                  )
                  (switch @state.parity
                    when 0 then (span {}, ' неделю')
                    when 1, 2 then (span {}, ' неделям')
                  )
                ]) if @state.parity >= 0)
              ])
            ])
          ])
          (div {className:'clearfix'})
          (div {className: 'col-xs-12'},
            (div {className: 'row'},
              (div {className: 'col-xs-6 col-sm-offset-6 add-btn-col'},
                  (button {className: 'btn btn-success form-control'}, 'Добавить')
              )
            )
          )
        ])
      ])
    ])