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

  getInitialState: ->
    _.assign({
      cancelType: 0
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
  			@setState cancelCount: value
  	else
  		@setState cancelCount: ''

  setDescription: (e)->
    @setState description: e.target.value

  onSwitchCancelType: (item)->
    @setState cancelType: item.value

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
              (div {className: 'col-xs-6 form-group'}, [
              	(label {className: classSet('sr-only': not @state.activity_start), htmlFor: 'actStart'}, 'Дата начала отмены')
                (dateTimePicker {id: 'actStart', className: 'form-control', maxView: 'date', format: 'dd.MM.yyyy', value: @state.activity_start, onChange: @setCancelStartDate})
              ])
              (if @state.cancelType == 1
              	(div {className: 'col-xs-6 form-group'}, [
              		(label {className: classSet('sr-only': not @state.cancelCount), htmlFor: 'actEnd'}, 'Количество отм. пар')
                	(input {id: 'actEnd', placeholder: 'Количество отм. пар', className: 'form-control', value: @state.cancelCount, onChange: @setCancelCount})
              	])
              )
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-12 form-group'}, [
                (switcher {
                  values: [
                    {name: 'Одну пару', value: 0}
                    {name: 'Несколько', value: 1}
                    {name: 'Полностью', value: 2}
                  ],
                  className: 'form-control'
                  value: @state.cancelType
                  onChange: @onSwitchCancelType
                })
              ])
            ])
            (div {className: 'row'}, [
              (div {className: 'col-xs-12 form-group'}, [
              	(label {className: classSet('sr-only': not @state.description), htmlFor: 'descr'}, 'Комментарий')
                (textarea {id: 'descr', placeholder: 'Комментарий', className: 'form-control',value: @state.description, onChange: @setDescription})
              ])
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
                  (button {className: 'btn btn-success form-control'}, 'Все верно, отменить!')
              )
            )
          )
        ])
      ])
    ])