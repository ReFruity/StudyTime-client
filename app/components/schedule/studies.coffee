{span, div} = React.DOM
{i18n, viewType} = requireComponents('/common', 'i18n', 'viewType')
{schedule, classCell, classDetails, nav, editor} = requireComponents('/schedule/parts', 'schedule', 'classCell',
  'classDetails', 'nav', 'editor')

##
# Studies navigation component
#
Navigation = React.createClass
  propTypes:
    group: React.PropTypes.object.isRequired
    sched: React.PropTypes.object.isRequired

  render: ->
    (div {className: 'container sched-nav'}, [
      (div {className: 'row'}, [
        (nav.EditorSwitcher {})
        (nav.BackToGroupsButton {group: @props.group})
        (nav.ScheduleTypeSwitcher {currentType:'studies', group: @props.group})
        (nav.UpdateIndicator {updated: new Date()})
        (nav.WeekSwitcher {})
      ])
    ])


##
# Studies schedule component
# Binds to group schedule model
#
module.exports = React.createClass
  propTypes:
    group: React.PropTypes.object.isRequired
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    sched:
      Mon:
        '1': [
          {subject:{name:'Мат. ан.'}, place:[{name:'623'}]}
        ]

  render: ->
    # Maybe show details
    if @props.route.dow and @props.route.number
      details =
        dow: @props.route.dow
        number: @props.route.number
        data: {}

    # Show navigation and schedule
    (div {className: 'studies'}, [
      @transferPropsTo(Navigation {sched: @state.sched})
      @transferPropsTo(schedule {
        cellElem: classCell("/#{@props.route.group}/studies")
        detailsElem: classDetails
        details: details
        sched: @state.sched})
    ])