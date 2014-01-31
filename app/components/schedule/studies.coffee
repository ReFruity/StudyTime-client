React = require 'react'
{span, div} = React.DOM
{i18n, viewType, modelMixin} = require '/components/common', 'i18n', 'viewType', 'modelMixin'
{Schedule} = require '/models', 'Schedule'
{schedule, classCell, classDetails, nav} = require '/components/schedule/parts', 'schedule', 'classCell',
  'classDetails', 'nav'
{editor} = require '/components/schedule/editor', 'editor'

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
    bounds: new Date().getWeekBounds()
    sched: new Schedule({type:'study', group: @props.route.group, faculty: @props.route.faculty, uni:@props.route.uni}).fetchThis()
    editor:
      mode: 0
      state: undefined

  getBackboneModels: ->
    [@state.sched]

  onSwitchWeek: (bounds) ->
    @setState
      bounds: bounds

  onSwitchEditor: (mode, state) ->
    @setState
      editor:
        mode: mode
        state: state

  componentDidMount: ->
    @interval = setInterval(@updateSchedule, 300000)

  componentWillUnmount: ->
    clearInterval(@interval)

  updateSchedule: ->
    new_bounds = new Date().getWeekBounds()
    if new_bounds[0].getTime() > @state.bounds[0].getTime()
      @onSwitchWeek(new_bounds)

  render: ->
    {route, group} = @props
    (div {className: 'studies'}, [
      # Editor
      (if @state.editor.mode > 0
        (editor {
          mode: @state.editor.mode,
          state: @state.editor.state,
          switchEditorHandler: @onSwitchEditor,
          timing: @state.sched.get('timing') or {}
        })
      )

      # Navigation
      (div {className: 'container sched-nav'}, [
        (div {className: 'row'}, [
          (nav.EditorSwitcher {editor: @state.editor, switchEditorHandler: @onSwitchEditor})
          (nav.BackToGroupsButton {group: @props.group})
          (nav.ScheduleTypeSwitcher {currentType:'studies', route: @props.route})
          (nav.UpdateIndicator {updated: (if @state.sched.fetchActive then null else @state.sched.get('updated') or new Date())})
          (nav.WeekSwitcher {switchWeekHandler: @onSwitchWeek, bounds: @state.bounds})
        ])
      ])

      # Schedule
      (schedule {
        weekDate: @state.bounds[0]
        cellElem: classCell
        detailsElem: classDetails
        sched: @state.sched.get('schedule') or {}
        timing: @state.sched.get('timing') or {}
        details: (
          try
            if @state.sched.get("schedule")[route.dow][route.number][route.atom]
              dow: route.dow
              number: route.number
              data: @state.sched.get("schedule")[route.dow][route.number][route.atom]
          catch e
            undefined
        )
        cellProps:
          baseUrl: "/#{route.uni}/#{route.faculty}/#{route.group}/studies"
          cellUrl: "/#{route.uni}/#{route.faculty}/#{route.group}/studies/#{route.dow}-#{route.number}-#{route.atom}"
          editor: @state.editor
          bounds: @state.bounds
          switchEditorHandler: @onSwitchEditor
          route: @props.route
      })
    ])