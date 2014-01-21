{span, div, a, i} = React.DOM
{i18n, viewType, relativeDate, dateFormat} = requireComponents('/common', 'i18n', 'viewType', 'relativeDate', 'dateFormat')
{classSet} = React.addons


module.exports =
  ##
  # Editor switcher. Can show/hide event editor
  #
  EditorSwitcher: React.createClass
    propTypes:
      switchEditorHandler: React.PropTypes.func.isRequired
      editor: React.PropTypes.object.isRequired

    toggleEditor: ->
      if @props.editor.mode > 0
        @props.switchEditorHandler(0)
      else
        @props.switchEditorHandler(1)

    render: ->
      (a {onClick: @toggleEditor}, 'editor')

  ##
  # Component for switching current showing schedule week
  # Invoke `@props.switchWeekHandler` with new week bounds
  # when week changed.
  #
  WeekSwitcher: React.createClass
    propTypes:
      switchWeekHandler: React.PropTypes.func.isRequired
      startDate: React.PropTypes.instanceOf(Date)

    getInitialState: ->
      in_feature: false
      start_date: @props.startDate or new Date()
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
      @props.switchWeekHandler(new_bounds)
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
            (dateFormat {date: @state.bounds.left, format: "dd MMM"})
          ])
          (span {}, ' − ')
          (a {onClick: @nextWeek}, [
            (dateFormat {date: @state.bounds.right, format: "dd MMM"})
            (i {className: 'stico-arrow-right'})
          ])
        ]
      ))

  ##
  # In other words, this is loading progress bar. It showes
  # 'Loading...' when `@props.updated` is undefined and
  # 'Loaded at <relative date>' when `@props.updated` is not empty
  #
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

  ##
  # Component for switching schedule type between 'studies'
  # and 'exams'
  #
  ScheduleTypeSwitcher: React.createClass
    propTypes:
      group: React.PropTypes.object.isRequired
      currentType: React.PropTypes.string.isRequired

    render: ->
      (div {className: 'sched-type-switcher'}, [
        (a {href: "/#{@props.group.get('name')}/studies", className: classSet('current': @props.currentType == 'studies')}, [
          (i18n {}, 'schedule.navigation.semestr')
        ])
        (a {href: "/#{@props.group.get('name')}/exams", className: classSet('current': @props.currentType == 'exams')}, [
          (i18n {}, 'schedule.navigation.session')
        ])
      ])

  ##
  # Back to groups button component. Nothing more.
  #
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