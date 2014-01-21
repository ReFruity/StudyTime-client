{span, div} = React.DOM
{i18n, viewType, modelMixin} = requireComponents('/common', 'i18n', 'viewType', 'modelMixin')
{Schedule} = requireModels('Schedule')
{schedule, classCell, classDetails, nav, editor} = requireComponents('/schedule/parts', 'schedule', 'classCell',
  'classDetails', 'nav', 'editor')

##
# Studies schedule component
# Binds to group's schedule model
# Periodically update schedule from server and rerender it
# Provides editor support
#
module.exports = React.createClass
  mixins: [modelMixin]
  propTypes:
    group: React.PropTypes.object.isRequired
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    editor:
      mode: 0
      data: undefined
    bounds: undefined
    sched: new Schedule({type:'study', group: @props.group.get('name'), faculty: 'ИМКН'}).fetchThis()

  getBackboneModels: ->
    [@state.sched]

  componentDidMount: ->
    @interval = setInterval(@updateSchedule, 300000)

  componentWillUnmount: ->
    clearInterval(@interval)

  updateSchedule: (bounds) ->
    bounds = @state.bounds unless bounds

  onSwitchWeek: (bounds) ->
    @updateSchedule(bounds)

  onSwitchEditor: (mode, data) ->
    @setState
      editor:
        mode: mode
        data: data

  render: ->
    {route, group} = @props
    (div {className: 'studies'}, [
      # Navigation
      (div {className: 'container sched-nav'}, [
        (div {className: 'row'}, [
          (nav.EditorSwitcher {editor: @state.editor, switchEditorHandler: @onSwitchEditor})
          (nav.BackToGroupsButton {group: @props.group})
          (nav.ScheduleTypeSwitcher {currentType:'studies', group: @props.group})
          (nav.UpdateIndicator {updated: new Date()})
          (nav.WeekSwitcher {switchWeekHandler: @onSwitchWeek})
        ])
      ])

      # Editor
      (if @state.editor.mode > 0
        (editor {mode: @state.editor.mode, data: @state.editor.data, switchEditorHandler: @onSwitchEditor})
      )

      # Schedule
      (schedule {
        cellElem: classCell("/#{route.group}/studies", @state.editor, @onSwitchEditor)
        detailsElem: classDetails("/#{route.group}/studies/#{route.dow}-#{route.number}-#{route.atom}", "/#{route.group}/studies")
        sched: @state.sched.get('schedule') or {}
        timing: @state.sched.get('timing') or {}
        details: (
          if @state.sched.has("schedule.#{route.dow}.#{route.number}.#{route.atom}")
            dow: route.dow
            number: route.number
            data: @state.sched.get("schedule.#{route.dow}.#{route.number}.#{route.atom}")
        )}
      )
    ])