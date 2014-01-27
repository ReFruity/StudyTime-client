{div, ul, li, a, i} = React.DOM
{i18n} = requireComponents('/common', 'i18n')
{classSet} = React.addons
{createEventForm, cancelEventForm, changeEventForm} = requireComponents('/schedule/editor', 'createEventForm',
  'cancelEventForm', 'changeEventForm')

##
# Switcher between editor modes
#
EditorSwitcher = React.createClass
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
            (i {className: "stico-plus"}, [])
            (i18n {}, 'schedule.editor.cancel_event')
          ])
        ])
        (li {className: classSet('current': @props.mode == 3)}, [
          (a {onClick: @onSwitchChanger}, [
            (i {className: "stico-plus"}, [])
            (i18n {}, 'schedule.editor.change_event')
          ])
        ])
      ])
    ])


##
# Main editor component
#
module.exports = React.createClass
  propTypes:
    mode: React.PropTypes.number.isRequired
    data: React.PropTypes.object
    timing: React.PropTypes.object.isRequired
    switchEditorHandler: React.PropTypes.func.isRequired

  onEventSubmit: (state)->
    console.log state

  render: ->
    data = @props.data or {}
    (div {className: 'event-editor'}, [
      (div {className: 'container'}, [
        (div {className: 'row'}, [
          @transferPropsTo(EditorSwitcher {})
          (if not data.date
            (div {className: 'select-cell'},
              (i18n {}, 'schedule.editor.select_cell')
              (i {className: 'stico-cell-mouse'})
            )
          else
            (switch @props.mode
              when 1 then @transferPropsTo(createEventForm {date: data.date, number: data.number, submitHandler: @onEventSubmit})
              when 2 then @transferPropsTo(cancelEventForm {date: data.date, event: data.event})
              when 3 then @transferPropsTo(changeEventForm {})
              else
                @transferPropsTo(createEventForm {date: data.date, number: data.number})
            )
          )
        ])
      ])
    ])