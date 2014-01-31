React = require 'react'
{div, input, a} = React.DOM
{Suggestions} = require '/models/Suggestions'
{classSet} = React.addons

DefaultItemElement = React.createClass
  render: ->
    (a {}, @props.item.name)

##
# Component for showing some suggestions for given
# model by given value (generally from some input field)
# Provides selection by pression keys up/down, enter
# and by click.
# You can put some custom suggestion item element to
# `itemElem` property. Item value will be in `item`
# propery.
#
module.exports = React.createClass
  propTypes:
    model: React.PropTypes.string.isRequired
    value: React.PropTypes.string.isRequired
    selectItemHandler: React.PropTypes.func.isRequired
    itemElem: React.PropTypes.func

  getDefaultProps: ->
    itemElem: DefaultItemElement

  getInitialState: ->
    showed: no
    items: []
    activeIndex: 0

  # Controller logic
  requestSuggestions: (text)->
    if not text or not text.trim().length
      @setState showed: no
    else
      @setState
        showed: yes
        activeIndex: 0
        items: [
          {name:'tetst', object:'123'}
          {name:'tetst 2', object:'123'}
          {name:'tetst 4', object:'123'}
        ]

  getActiveItem: ->
    @state.items[@state.activeIndex] if @state.items.length > 0

  activateNextItem: ->
    if @state.activeIndex + 1 < @state.items.length
      @setState activeIndex: @state.activeIndex + 1
    else
      @setState activeIndex: 0

  activatePrevItem: ->
    if @state.activeIndex - 1 >= 0
      @setState activeIndex: @state.activeIndex - 1
    else if @state.items.length > 0
      @setState activeIndex: @state.items.length - 1

  activate: (indx)->
    @setState activeIndex: indx

  select: (indx)->
    if @state.items.length > 0
      @props.selectItemHandler(@state.items[indx])
      @setState
        showed: no
        items: []

  onKeyUp: (e)->
    if @state.items.length
      if e.keyCode is 13
        @select(@state.activeIndex)
      if e.keyCode is 27
        @setState
          showed: no
          items: []

  onKeyDown: (e)->
    if @state.items.length > 0
      if e.keyCode is 9
        @select(@state.activeIndex)

      if e.keyCode in [13,27,40,38]
        e.preventDefault()
        @activateNextItem() if e.keyCode is 40
        @activatePrevItem() if e.keyCode is 38

  onMouseDown: (e, i)->
    e.preventDefault()
    @select(i)

  onMouseEnter: (e, i)->
    self.activate(i)

  componentWillReceiveProps: (props)->
    @requestSuggestions(props.value)

  componentDidMount: ->
    @requestSuggestions(@props.value)
    $(window).on
      keyup: @onKeyUp
      keydown: @onKeyDown

  componentWillUnmount: ->
    $(window).off
      keyup: @onKeyUp
      keydown: @onKeyDown

  render: ->
    self = @
    (div {className: classSet('suggestions':yes, 'invisible': not @state.items.length or not @state.showed)},
      (div {className: 'wrapper'},
        @state.items.map (item, i) ->
          (div {
            onMouseEnter: ((e)->self.onMouseEnter(e, i)),
            onMouseDown: ((e)->self.onMouseDown(e, i)),
            className: classSet('current': self.state.activeIndex == i)},
            (self.props.itemElem {item: item})
          )
      )
    )