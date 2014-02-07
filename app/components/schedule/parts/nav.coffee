React = require 'react'
helpers = require 'helpers'
{span, div, a, i, ul, li} = React.DOM
{i18n, viewType, relativeDate, dateFormat} = require '/components/common', 'i18n', 'viewType', 'relativeDate', 'dateFormat'
{classSet} = React.addons


module.exports =

  ##
  # Control for making setting home group
  #
  MyGroup: React.createClass
    getInitialState: ->
      tooltipShowed: no

    toggleTooltipOn: ->
      @setState tooltipShowed: yes

    toggleTooltipOff: ->
      @setState tooltipShowed: no

    render: ->
      div {className: 'heart-btn', onMouseEnter: @toggleTooltipOn, onMouseLeave: @toggleTooltipOff},
        i {className: 'stico-heart heartbeat'}
        span {}, 'Моя группа' if @state.tooltipShowed

  ##
  # Editor switcher. Can show/hide event editor
  #
  EditorSwitcher: React.createClass
    propTypes:
      switchEditorHandler: React.PropTypes.func.isRequired
      editor: React.PropTypes.object.isRequired
      data: React.PropTypes.object
      date: React.PropTypes.object
      dow: React.PropTypes.string
      number: React.PropTypes.string

    getInitialState: ->
      showDropDown: no

    toggleEditor: ->
      if @props.editor.mode > 0
        @props.switchEditorHandler(0)
      else
        @props.switchEditorHandler(1)
      @setState showDropDown: no

    showDropDown: ->
      @setState showDropDown: yes

    hideDropDown: ->
      @setState showDropDown: no

    switchEditor: (mode)->
      @hideDropDown()
      @props.switchEditorHandler(mode, @createStateFromEvent(mode))
      helpers.scrollTop(0) if @props.data

    createStateFromEvent: (mode)->
      return if not @props.data
      atom = @props.data
      selectedDate: @props.date
      number: @props.number
      dow: @props.dow
      parity: atom.parity
      half_group: atom.half_group
      place: atom.place or []
      type: atom.type
      subject: atom.subject
      professor: atom.professor or []
      activity_start: (if mode == 2 then @props.date else new Date(atom.activity.start))
      activity_end: new Date(atom.activity.end)
      description: atom.description
      _id: atom._id

    render: ->
      self = @
      div {onMouseEnter: @showDropDown, onMouseLeave: @hideDropDown, className: classSet('editor-btn': yes, 'current': @props.editor.mode > 0 or @state.showDropDown)},
        a {onClick: @toggleEditor},
          i {className: 'stico-edit'}

        if @state.showDropDown
          div {className: 'drop-down'}, [
            div {className: 'menu-wrapper'},
              ul {className: 'menu'},
                li {onClick: (->self.switchEditor(1))}, 'Добавить пару' if not @props.data
                li {onClick: (->self.switchEditor(2))}, 'Отменить пару'
                li {onClick: (->self.switchEditor(3))}, 'Изменить пару'
          ]


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
      newBounds = now.getWeekBounds()
      @props.switchWeekHandler(newBounds)

    nextWeek: ->
      @changeWeek(1)

    prevWeek: ->
      @changeWeek(-1)

    render: ->
      inFeature = @props.bounds[0] > new Date()

      (div {className: classSet('sched-week-switcher':yes, 'feature':inFeature)}, (
        if not inFeature
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
      (div {className: 'sched-update-indicator'}, (
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