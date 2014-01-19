{span, div} = React.DOM
{i18n, viewType} = requireComponents('/common', 'i18n', 'viewType')
{schedule, classCell, classDetails, nav, editor} = requireComponents('/schedule/parts', 'schedule', 'classCell',
  'classDetails', 'nav', 'editor')


Navigation = React.createClass
  propTypes:
    group: React.PropTypes.object.isRequired
    switchTypeHandler: React.PropTypes.func.isRequired
    sched: React.PropTypes.object.isRequired

  render: ->
    (div {className: 'container sched-nav'}, [
      (div {className: 'row'}, [
        (nav.EditorSwitcher {})
        (nav.BackToGroupsButton {group: @props.group})
        (nav.ScheduleTypeSwitcher {currentType:'studies' ,switchTypeHandler: @props.switchTypeHandler})
        (nav.UpdateIndicator {updated: new Date()})
        (nav.WeekSwitcher {})
      ])
    ])


module.exports = React.createClass
  propTypes:
    group: React.PropTypes.object.isRequired
    switchTypeHandler: React.PropTypes.func.isRequired

  getInitialState: ->
    sched: {}

  render: ->
    (div {className: 'studies'}, [
      @transferPropsTo(Navigation {sched: @state.sched})
      @transferPropsTo(schedule {cellElem: classCell, detailsElem: classDetails, sched: @state.sched})
    ])