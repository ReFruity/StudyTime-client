{span, div} = React.DOM
{i18n, viewType} = requireComponents('/common', 'i18n', 'viewType')
{eventsList, classRow, examDetails, nav, editor} = requireComponents('/schedule/parts', 'eventsList', 'classRow',
  'examDetails', 'nav', 'editor')

##
# Exams schedule component
# Binds to group's exams schedule model
# Periodically update schedule from server and rerender it
# Provides editor support
#
module.exports = React.createClass
  propTypes:
    group: React.PropTypes.object.isRequired
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    editor:
      mode: 0
      data: undefined
    events: []

  componentDidMount: ->
    @interval = setInterval(@updateSchedule, 300000)

  componentWillUnmount: ->
    clearInterval(@interval)

  updateSchedule: (bounds) ->
    ""

  onSwitchEditor: (mode, data) ->
    @setState
      editor:
        mode: mode
        data: data

  render: ->
    {route, group} = @props
    (div {className: 'exams'}, [
      # Navigation
      (div {className: 'container sched-nav'}, [
        (div {className: 'row'}, [
          (nav.EditorSwitcher {editor: @state.editor, switchEditorHandler: @onSwitchEditor})
          (nav.BackToGroupsButton {group: @props.group})
          (nav.ScheduleTypeSwitcher {currentType:'exams', group: @props.group})
          (nav.UpdateIndicator {updated: new Date()})
        ])
      ])

      # Editor
      (if @state.editor.mode > 0
        (editor {mode: @state.editor.mode, data: @state.editor.data, switchEditorHandler: @onSwitchEditor})
      )

      # Events list
      (eventsList {
        rowElem: classRow("/#{route.group}/exams", @state.editor, @onSwitchEditor)
        detailsElem: examDetails("/#{route.group}/exams/#{route.event}", "/#{route.group}/exams")
        events: @state.events
        details: (
          try
            if @state.events[route.event]
              index: route.event
              data: @state.events[route.event]
          catch
            undefined
        )}
      )
    ])