React = require 'react'
Gator = require 'gator'
_ = require 'underscore'

{div, input, a} = React.DOM
{Suggestions} = require '/models', 'Suggestions'
{modelMixin} = require '/components/common', 'modelMixin'
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
  mixins: [modelMixin]
  propTypes:
    model: React.PropTypes.string.isRequired
    selectItemHandler: React.PropTypes.func.isRequired
    itemElem: React.PropTypes.func
    inputId: React.PropTypes.string.isRequired

  getBackboneModels: ->
    [@state.items]

  getDefaultProps: ->
    itemElem: DefaultItemElement

  getInitialState: ->
    showed: no
    items: new Suggestions().modelType(@props.model)
    activeIndex: 0

  # Controller logic
  requestSuggestions: (text)->
    self = @
    if _.isString(text) and @lastValue != text.trim() and text.trim().length > 0
      clearTimeout(@reqTimeOut) if @reqTimeOut
      @reqTimeOut = setTimeout(->
        self.state.items.find(text)
        self.setState activeIndex: 0
      , 60)
    else
      @state.items.reset()

  getActiveItem: ->
    _.clone(@state.items.at(@state.activeIndex).attributes) if @state.items.length > 0

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
    if @state.items.length and @state.showed
      value = _.clone(@state.items.at(indx).attributes)
      @lastValue = value.name
      @props.selectItemHandler(value)
      @state.items.reset()

  onKeyUp: (e)->
    if @state.items.length and @state.showed
      if e.keyCode is 13
        @select(@state.activeIndex)
      if e.keyCode is 27
        @state.items.reset()

  onKeyDown: (e)->
    if @state.items.length and @state.showed
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
    @activate(i)

  onFocus: ->
    @setState showed: yes

  onBlur: ->
    @setState showed: no

  componentWillReceiveProps: (props)->
    @requestSuggestions(props.value)

  componentDidMount: ->
    @requestSuggestions(@props.value)
    Gator(document.getElementById(@props.inputId)).on 'focus', @onFocus
    Gator(document.getElementById(@props.inputId)).on 'blur', @onBlur
    Gator(window).on 'keyup', @onKeyUp
    Gator(window).on 'keydown', @onKeyDown

  componentWillUnmount: ->
    Gator(document.getElementById(@props.inputId)).off 'focus', @onFocus
    Gator(document.getElementById(@props.inputId)).off 'blur', @onBlur
    Gator(window).off 'keyup', @onKeyUp
    Gator(window).off 'keydown', @onKeyDown

  render: ->
    self = @
    (div {className: classSet('suggestions':yes, 'invisible': not @state.items.length or not @state.showed)},
      (div {className: 'wrapper'},
        @state.items.map (item, i) ->
          (div {
            onMouseEnter: ((e)->self.onMouseEnter(e, i)),
            onMouseDown: ((e)->self.onMouseDown(e, i)),
            className: classSet('current': self.state.activeIndex == i)},
            (self.props.itemElem {item: item.attributes})
          )
      )
    )