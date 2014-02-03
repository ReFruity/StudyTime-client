React = require 'react'
{span, div, a, i} = React.DOM
{i18n, viewType, relativeDate, dateFormat} = require '/components/common', 'i18n', 'viewType', 'relativeDate', 'dateFormat'
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
      (div {className: classSet('editor-btn': yes, 'current': @props.editor.mode > 0)},
        (a {onClick: @toggleEditor},
          (i {className: 'stico-edit'})
        )
      )

  ##
  # Component for switching current showing schedule week
  # Invoke `@props.switchWeekHandler` with new week bounds
  # when week changed.
  #
  WeekSwitcher: React.createClass
    propTypes:
      switchWeekHandler: React.PropTypes.func.isRequired
      bounds: React.PropTypes.array.isRequired

    changeWeek: (direction)->
      now = new Date(@props.bounds[1])
      now.setDate(now.getDate() + direction * 7)
      new_bounds = now.getWeekBounds()
      @props.switchWeekHandler(new_bounds)

    nextWeek: ->
      @changeWeek(1)

    prevWeek: ->
      @changeWeek(-1)

    render: ->
      in_feature = @props.bounds[0] > new Date()

      (div {className: classSet('sched-week-switcher':yes, 'feature':in_feature)}, (
        if not in_feature
          (a {onClick: @nextWeek}, [
            (i18n {}, 'schedule.navigation.next_week')
            (i {className: 'stico-arrow-right'})
          ])
        else [
          (a {onClick: @prevWeek}, [
            (i {className: 'stico-arrow-right rotate-180'})
            (dateFormat {date: @props.bounds[0], format: "dd MMM"})
          ])
          (span {}, ' − ')
          (a {onClick: @nextWeek}, [
            (dateFormat {date: @props.bounds[1], format: "dd MMM"})
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
      route: React.PropTypes.object.isRequired
      currentType: React.PropTypes.string.isRequired

    render: ->
      (div {className: 'sched-type-switcher'}, [
        (a {href: "/#{@props.route.uni}/#{@props.route.faculty}/#{@props.route.group}/studies", className: classSet('current': @props.currentType == 'studies')}, [
          (i18n {}, 'schedule.navigation.semestr')
        ])
        (a {href: "/#{@props.route.uni}/#{@props.route.faculty}/#{@props.route.group}/exams", className: classSet('current': @props.currentType == 'exams')}, [
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
          (i {className: 'stico-arrow-right rotate-180'})
          (div {className: 'back-logo-square'}, [
            (i {className: 'stico-groups-list'})
          ])
          (span {}, @props.group.get('name'))
        ])
      ])