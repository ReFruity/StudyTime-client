{span, div, a, ul, li, i, form, input, label, select, option, textarea, button} = React.DOM
{i18n} = requireComponents('/common', 'i18n')
{classSet} = React.addons

##
# Switcher between editor modes
#
EditorSwitcher = React.createClass
  onSwitchAdder: ->
    @props.switchEditorHandler(1)

  onSwitchCanceler: ->
    @props.switchEditorHandler(2)

  onSwitchChanger: ->
    @props.switchEditorHandler(3)

  render: ->
    (div {className: 'editor-switcher'}, [
      (ul {}, [
        (li {className: classSet('current': @props.mode == 1)}, [
          (a {onClick: @onSwitchAdder}, [
            (div {}, (i {className: "stico-plus"}, []))
            (i18n {}, 'schedule.editor.add_event')
          ])
        ])
        (li {className: classSet('current': @props.mode == 2)}, [
          (a {onClick: @onSwitchCanceler}, [
            (div {}, (i {className: "stico-plus"}, []))
            (i18n {}, 'schedule.editor.cancel_event')
          ])
        ])
        (li {className: classSet('current': @props.mode == 3)}, [
          (a {onClick: @onSwitchChanger}, [
            (div {}, (i {className: "stico-plus"}, []))
            (i18n {}, 'schedule.editor.change_event')
          ])
        ])
      ])
    ])


##
# Show a form for creating new event (or replacement)
# On submit it creates new event with higher priority
#
CreateEvent = React.createClass
  propTypes:
    date: React.PropTypes.object
    number: React.PropTypes.string

  getInitialState: ->
    event: {}

  onSubmitForm: (e)->
    e.preventDefault()
    console.log "submit"

  render: ->
    (div {className: 'cr-event'}, [
      (if not @props.date
        (div {},
          (i18n {}, 'schedule.editor.select_cell')
        )
      else
        (form {onSubmit: @onSubmitForm, role: 'form'}, [
          # Professor, Subject
          (div {className: 'row'}, [
            (div {className: 'col-xs-6 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'subjectInput'}, 'Название предмета')
              (input {id: 'subjectInput', className: 'form-control', placeholder: 'Название предмета'})
            ])
            (div {className: 'col-xs-6 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'proffInput'}, 'Преподаватель')
              (input {id: 'proffInput', className: 'form-control', placeholder: 'Преподаватель'})
            ])
          ])

          # Place, Event type, Start date, End date
          (div {className: 'row'}, [
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'placeInput'}, 'Аудитория')
              (input {id: 'placeInput', className: 'form-control', placeholder: 'Аудитория'})
            ])
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'typeInput'}, 'Тип события')
              (select {id: 'typeInput', className: 'form-control', placeholder: 'Тип события'}, [
                (option {value: undefined}, '-- Тип события --')
                (option {value: 'exam'}, 'Экзамен')
                (option {value: 'test'}, 'Зачет')
                (option {value: 'lecture'}, 'Лекция')
                (option {value: 'practice'}, 'Практика')
              ])
            ])
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'startDateInput'}, 'Дата и Время начала')
              (input {id: 'startDateInput', className: 'form-control', placeholder: 'Дата и Время начала'})
            ])
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'startDateInput'}, 'Дата и Время окончания')
              (input {id: 'startDateInput', className: 'form-control', placeholder: 'Дата и Время окончания'})
            ])
          ])

          # Day of week, Class number, Parity, Group part
          (div {className: 'row'}, [
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'dowInput'}, 'День недели')
              (select {id: 'dowInput', className: 'form-control', placeholder: 'День недели'}, [
                (option {value: undefined}, '-- День недели --')
                (option {value: 'Mon'}, 'Понедельник')
              ])
            ])
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'typeInput'}, 'Номер пары')
              (select {id: 'typeInput', className: 'form-control', placeholder: 'Номер пары'}, [
                (option {value: undefined}, '-- Номер пары --')
                (option {value: 1}, '1')
                (option {value: 2}, '2')
                (option {value: 3}, '3')
                (option {value: 4}, '4')
              ])
            ])
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'parityInput'}, 'Повторяемость')
              (select {id: 'parityInput', className: 'form-control', placeholder: 'День недели'}, [
                (option {value: undefined}, '-- Повторяемость --')
                (option {value: 0}, 'Каждую неделю')
                (option {value: 2}, 'По четным')
                (option {value: 1}, 'По нечетным')
              ])
            ])
            (div {className: 'col-xs-3 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'hgInput'}, 'Часть гргуппы')
              (select {id: 'hgInput', className: 'form-control', placeholder: 'Часть группы'}, [
                (option {value: undefined}, '-- Часть группы --')
                (option {value: 0}, 'Вся группа')
                (option {value: 1}, 'Первая подгруппа')
                (option {value: 2}, 'Вторая подгруппа')
              ])
            ])
          ])

          # Description
          (div {className: 'row'}, [
            (div {className: 'col-xs-12 form-group'}, [
              (label {className: 'sr-only', htmlFor: 'descInput'}, 'Описание')
              (textarea {id: 'descInput', className: 'form-control', placeholder: 'Описание'})
            ])
          ])

          # Add/Cancel buttons
          (div {className: 'row'}, [
            (div {className: 'col-xs-9 form-group'}, [
              (button {className: 'btn btn-success form-control'}, 'Добавить')
            ])
            (div {className: 'col-xs-3 form-group'}, [
              (button {className: 'btn btn-default form-control'}, 'Очистить')
            ])
          ])
        ])
      )
    ])


##
# Provides functionality for canceling events
# On submit it cancels selected in schedule event
#
CancelEvent = React.createClass
  propTypes:
    date: React.PropTypes.object
    event: React.PropTypes.object

  getInitialState: ->
    event: {}

  render: ->
    (div {className: 'ccl-event'}, [
      (if not @props.date
        (div {},
          (i18n {}, 'schedule.editor.select_cancel_cell')
        )
      else
        (div {}, 'ok')
      )
    ])


##
# The same that creator but provides posibility
# of selection any event in schedule for auto fill
# the form. On submit it changes selected event.
#
ChangeEvent = React.createClass
  getInitialState: ->
    event: {}

  render: ->
    (div {className: 'ch-event'}, [

    ])


##
# Main editor component
#
module.exports = React.createClass
  propTypes:
    mode: React.PropTypes.number.isRequired
    data: React.PropTypes.object
    switchEditorHandler: React.PropTypes.func.isRequired

  render: ->
    data = @props.data or {}
    (div {className: 'event-editor'}, [
      (div {className: 'container'}, [
        (div {className: 'row'}, [
          @transferPropsTo(EditorSwitcher {})
          (switch @props.mode
            when 1 then @transferPropsTo(CreateEvent {date: data.date, number: data.number})
            when 2 then @transferPropsTo(CancelEvent {date: data.date, event: data.event})
            when 3 then @transferPropsTo(ChangeEvent {})
            else @transferPropsTo(CreateEvent {})
          )
        ])
      ])
    ])
