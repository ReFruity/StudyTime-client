'use strict'

{ul, li, div, h5, h4, form, input, button, span} = React.DOM
{classSet} = React.addons

###
TodoList = React.createClass
  render: ->
    createItem = (itemText) ->
      (li {}, [itemText])
    (ul {}, [@props.items.map createItem]);

TodoApp = React.createClass
  getInitialState: ->
    items: []
    text: ''

  handleSubmit: (e) ->
    e.preventDefault();
    nextItems = @state.items.concat [this.state.text]
    nextText = ''
    @setState items: nextItems, text: nextText

  render: ->
    (div {}, [
      (h3 {}, ['TODO']),
      (TodoList {items: @state.items})
      (form {onSubmit: @handleSubmit}, [
        (input {onKeyUp: @onKey, value: @state.text}),
        (button {}, ['Add #' + (@state.items.length + 1)])
      ])
    ])
###

Schedule = React.createClass
  getInitialState: ->
    sched: {}
    currentDow: 'Mon'
    currentClass: '6'

  render: ->
    self = @
    (div {className: 'desktop', id: 'schedule-greed'}, [
      ([
        ['Mon', 'Tue', 'Wed']
        ['Thu', 'Fri', 'Sat']
      ].map (line)->
        (div {className: 'lessons-grid'}, [
          # Day of weeks
          (div {className: 'container'}, [
            (div {className: 'row'}, [
              (line.map (dow)->
                (div {className: 'col-sm-4'}, [
                  (h5 {className: classSet(current: (self.state.currentDow == dow), 'lesson-cell-title': true)}, [
                    (span {className: 'lesson-cell-title-day'}, [dow])
                  ])
                ])
              )
            ])
          ])

          # Classes
          (['1', '2', '3', '4', '5', '6'].map (clazz)->
            (div {className: 'container lessons-row'}, [
              (div {className: 'row'}, [

                # Class time
                (div {className: 'lesson-time-wrapper'}, [
                  (div {className: classSet(current: (self.state.currentClass == clazz and self.state.currentDow in line), 'lesson-time': true)}, [
                    (h4 {className: 'lesson-time-number'}, [clazz])
                    (h5 {className: 'lesson-time-start'}, [clazz])
                  ])
                ])

                # Class for each dow
                (line.map (dow)->
                  (div {className: 'lesson-cell-wrapper col-sm-4'}, [
                    (div {className: classSet(current: (self.state.currentClass == clazz and self.state.currentDow == dow), 'lesson-cell': true)}, [
                      ([0..20].map (i)->
                        (div {className: 'free-place'}, [i])
                      )
                    ])
                  ])
                )

              ])
            ])
          )
        ])
      )
    ])

React.renderComponent (Schedule {}), document.body