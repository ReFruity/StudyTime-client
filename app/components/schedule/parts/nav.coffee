{span, div, a, i} = React.DOM
{i18n, viewType, relativeDate, date} = requireComponents('/common', 'i18n', 'viewType', 'relativeDate', 'date')
{classSet} = React.addons


module.exports =
  EditorSwitcher: React.createClass
    render: ->
      (div {}, 'editor')


  WeekSwitcher: React.createClass
    propTypes:
      switchWeekHandler: React.PropTypes.func #.isRequired

    getInitialState: ->
      in_feature: false
      start_date: new Date()
      bounds: @getBounds(new Date())

    getBounds: (date)->
      bw = {0: 6, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5}
      left = new Date(date)
      left.setDate(left.getDate() - bw[left.getDay()])
      right = new Date(left)
      right.setDate(left.getDate() + 6)
      left:left
      right:right

    changeWeek: (direction)->
      now = new Date(@state.bounds.right)
      now.setDate(now.getDate() + direction * 7)
      new_bounds = @getBounds(now)
      @setState(
        in_feature: new_bounds.left > @state.start_date
        bounds: new_bounds
      )

    nextWeek: ->
      @changeWeek(1)

    prevWeek: ->
      @changeWeek(-1)

    render: ->
      (div {className: 'sched-week-switcher'}, (
        if not @state.in_feature
          (a {onClick: @nextWeek}, [
            (i18n {}, 'schedule.navigation.next_week')
            (i {className: 'stico-arrow-right'})
          ])
        else [
          (a {onClick: @prevWeek}, [
            (i {className: 'stico-arrow-right rotate-180'})
            (date {date: @state.bounds.left, format: "dd MMM"})
          ])
          (span {}, ' − ')
          (a {onClick: @nextWeek}, [
            (date {date: @state.bounds.right, format: "dd MMM"})
            (i {className: 'stico-arrow-right'})
          ])
        ]
      ))


  UpdateIndicator: React.createClass
    render: ->
      (div {className: 'sched-upd-indicator'}, (
        if @props.updated
          [
            (i18n {}, 'schedule.navigation.updated')
            (span {}, ' ')
            (relativeDate {date: @props.updated})
          ]
        else
          (i18n {}, 'schedule.navigation.updating')
      ))


  ScheduleTypeSwitcher: React.createClass
    propTypes:
      switchTypeHandler: React.PropTypes.func.isRequired
      currentType: React.PropTypes.string.isRequired

    switchType: (e)->
      console.log e.dispatchConfig

    render: ->
      self = @
      (div {className: 'sched-type-switcher'}, [
        (a {className: classSet('current': @props.currentType == 'studies'), onClick: -> self.props.switchTypeHandler('studies')}, [
          (i18n {}, 'schedule.navigation.semestr')
        ])
        (a {className: classSet('current': @props.currentType == 'exams'), onClick: -> self.props.switchTypeHandler('exams')}, [
          (i18n {}, 'schedule.navigation.session')
        ])
      ])


  BackToGroupsButton: React.createClass
    propTypes:
      group: React.PropTypes.object.isRequired

    render: ->
      (div {className: 'back-groups-btn'}, [
        (a {}, [
          (div {className: 'back-logo-square'}, [
            (i {className: 'stico-groups-list'})
          ])
          (span {}, @props.group.name)
        ])
      ])