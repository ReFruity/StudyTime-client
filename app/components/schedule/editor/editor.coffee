React = require 'react'
_ = require 'underscore'
{div, ul, li, a, i, h2, p, span} = React.DOM
{i18n, viewType} = require '/components/common', 'i18n', 'viewType'
{classSet} = React.addons
{createEventForm, cancelEventForm, changeEventForm} = require '/components/schedule/editor', 'createEventForm',
  'cancelEventForm', 'changeEventForm'

##
# Switcher between editor modes
#
EditorSwitcher = React.createClass
  propTypes:
    mode: React.PropTypes.number.isRequired
    switchEditorHandler: React.PropTypes.func.isRequired

  onSwitchAdder: ->
    @props.switchEditorHandler(1) if @props.mode != 1

  onSwitchCanceler: ->
    @props.switchEditorHandler(2) if @props.mode != 2

  onSwitchChanger: ->
    @props.switchEditorHandler(3) if @props.mode != 3

  render: ->
    (div {className: 'editor-switcher'}, [
      (ul {}, [
        (li {className: classSet('current': @props.mode == 1)}, [
          (a {onClick: @onSwitchAdder}, [
            (i {className: "stico-plus"}, [])
            (i18n {}, 'schedule.editor.add_event')
          ])
        ])
        (li {className: classSet('current': @props.mode == 2)}, [
          (a {onClick: @onSwitchCanceler}, [
            (i {className: "stico-cancel"}, [])
            (i18n {}, 'schedule.editor.cancel_event')
          ])
        ])
        (li {className: classSet('current': @props.mode == 3)}, [
          (a {onClick: @onSwitchChanger}, [
            (i {className: "stico-edit-pen"}, [])
            (i18n {}, 'schedule.editor.change_event')
          ])
        ])
      ])
    ])


##
# 'Thanks' window
#
EditorFinalStage = React.createClass
  propTypes:
    mode: React.PropTypes.number.isRequired
    switchEditorHandler: React.PropTypes.func.isRequired

  getInitialState: ->
    notifyStatus: 0

  sendNotification: ->
    @setState notifyStatus: 1

  render: ->
    self = @
    div {className: 'thanks-wnd'}, [
      div {className: 'wrapper'}, [
        h2 {}, 'Спасибо!'
        p {}, 'Жизнь группы стала чуточку лучше. Или хуже, в зависимости от того, что изменилось :)'
        switch @state.notifyStatus
          when 0 then a {className: 'notify-btn', onClick: @sendNotification}, 'Оповестить группу'
          when 1 then span {className: 'notify-sending'}, 'Отправка оповещений, подождите немного...'
          when 2 then span {className: 'notify-done'}, 'Все готово!'
      ]
      div {className: 'buttons'}, [
        a {onClick:(->self.props.switchEditorHandler(self.props.mode))}, 'Продолжить изменения'
        a {onClick:(->self.props.switchEditorHandler(0))}, 'Закончить'
      ]
    ]


##
# Main editor component
# It have only controller methods for sending data
# Form validation must be in editor components
#
module.exports = React.createClass
  propTypes:
    mode: React.PropTypes.number.isRequired
    state: React.PropTypes.object
    timing: React.PropTypes.object.isRequired
    switchEditorHandler: React.PropTypes.func.isRequired
    updateSchedHandler: React.PropTypes.func.isRequired
    cellSelector: React.PropTypes.boolean
    eventTypes: React.PropTypes.array

  # Show final stage
  showFinalStage: (state)->
    @props.switchEditorHandler(@props.mode, _.assign({finalStage: yes}, state))

  # Create new event based on editor state
  createEvent: (state)->
    @showFinalStage(state)
    @props.updateSchedHandler()

  # Create new event based on editor state
  cancelEvent: (state)->
    @showFinalStage(state)
    @props.updateSchedHandler()

  # Update event based on editor state
  updateEvent: (state)->
    @showFinalStage(state)
    @props.updateSchedHandler()

  render: ->
    (div {className: 'event-editor'}, [
      (div {className: 'container'}, [
        (div {className: 'row'}, [
          (EditorSwitcher {mode: @props.mode, switchEditorHandler: @props.switchEditorHandler})
          (if not @props.state and @props.cellSelector
            (div {className: 'select-cell'},
              i18n {}, 'schedule.editor.select_cell'
              i {className: 'stico-cell-mouse'},
                switch @props.mode
                  when 1 then 'добавить'
                  when 2 then 'отменить'
                  when 3 then 'изменить'
            )
          else
            (div {className: 'editor-row'},
              (switch @props.mode
                when 1 then (createEventForm {state: @props.state, switchEditorHandler: @props.switchEditorHandler, submitHandler: @createEvent, eventTypes: @props.eventTypes})
                when 2 then (cancelEventForm {state: @props.state, switchEditorHandler: @props.switchEditorHandler, submitHandler: @cancelEvent, eventTypes: @props.eventTypes})
                when 3 then (changeEventForm {state: @props.state, switchEditorHandler: @props.switchEditorHandler, submitHandler: @updateEvent, eventTypes: @props.eventTypes})
                else
                  throw new Error("Given editor mode not suported: #{@props.mode}")
              )
            )
          )
          (if @props.state and @props.state.finalStage
            (EditorFinalStage {mode: @props.mode, switchEditorHandler: @props.switchEditorHandler})
          )
        ])
      ])
    ])