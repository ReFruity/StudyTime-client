{ul, li, input, div, span} = React.DOM
{suggestions} = requireComponents('/common', 'suggestions')

##
# Tag item element
#
TagItem = React.createClass
  onClick: ->
    @props.removeTagHandler(@props.index)

  render: ->
    (li {className: 'item-li', onClick: @onClick}, [
      (span {}, @props.item.name)
      (span {className: 'close'}, '×')
    ])

##
# Input element with tag separation support
#
InputItem = React.createClass
  getDefaultProps: ->
    allowSpace: no
    allowComma: no

  getInitialState: ->
    value: ''

  # Focus on the input
  focus: ->
    @refs.tagInput.getDOMNode().focus()

  # If last symbol is comma and comma not allowed
  # by property and comma is not one symbol in the inpu
  # then create new tag
  onChange: (e)->
    value = e.target.value.trim()
    if value.length > 1 and value[value.length - 1] == ',' and not @props.allowComma
      @addTag({name: value.substr(0, value.length - 1), object: ''})
    else
      @setState value: e.target.value

  # Handles removing last tag if backspace pressed on empty input
  # Also handles space and enter presses for creating new tag
  onKeyDown: (e)->
    if e.keyCode is 8 and not @state.value.length and not @removeTagTimer
      self = @
      @props.removeLastTagHandler()
      @removeTagTimer = setTimeout(->
        self.removeTagTimer = undefined
      , 200)

    else if (e.keyCode in [13, 9] or (not @props.allowSpace and e.keyCode is 32)) and @state.value.trim().length > 0
      e.preventDefault() unless e.keyCode == 9
      if e.keyCode not in [13, 9] or not @refs['sugg'].getActiveItem()
        @addTag({name: @state.value.trim(), object: ''})

  # Create new tag if input is not empty
  onBlur: (e)->
    if @state.value.trim().length > 0
      sugg = @refs['sugg'].getActiveItem()
      @addTag(if sugg then sugg else {name: @state.value.trim(), object: ''})

  # When user select some suggection
  onSelectSuggestion: (item)->
    @addTag(item)

  # Add new tag and set input empty value
  addTag: (item)->
    @props.addTagHandler(item)
    @setState value: ''
    @approximateInputWidth()

  # Approximate width of the input for being in one line
  # with last tag item
  approximateInputWidth: ->
    self = @
    $(self.getDOMNode()).width(0)
    setTimeout(->
      prevItem = $(self.getDOMNode()).prev()
      if prevItem.length > 0
        container = prevItem.parent()
        wrapper = container.parent()
        width = wrapper.width() - prevItem.width() - (wrapper.width() - container.width())/2 + wrapper.position().left - 5 - prevItem.position().left
        $(self.getDOMNode()).width(if width > 50 then width else '100%')
    , 0)

  render: ->
    (li {className: 'input-li'}, [
      (input {
        ref: 'tagInput',
        value: @state.value
        onBlur: @onBlur,
        onChange: @onChange,
        onKeyDown: @onKeyDown,
        placeholder: @props.placeholder
      })
      (if @props.suggestions
        (suggestions {ref: 'sugg', value: @state.value, model: @props.suggestions, selectItemHandler: @onSelectSuggestion})
      )
    ])

##
# Stateless controlled tagged input component
# Invoke given `props.onChange` method with
# list of new tags
#
module.exports = React.createClass
  propTypes:
    suggestions: React.PropTypes.string
    onChange: React.PropTypes.func
    value: React.PropTypes.array
    allowSpace: React.PropTypes.boolean
    allowComma: React.PropTypes.boolean
    id: React.PropTypes.string
    className: React.PropTypes.string

  focusToInput: ->
    @refs['tagInput'].focus()

  onRemoveLastTag: ->
    if @props.onChange and @props.value and @props.value.length > 0
      newTags = _.clone(@props.value)
      newTags.pop()
      @props.onChange(newTags)

  onRemoveTag: (indx)->
    if @props.onChange and @props.value and @props.value.length > 0
      newTags = _.clone(@props.value)
      newTags.splice(indx, 1)
      @props.onChange(newTags)

  onAddTag: (item)->
    if @props.onChange
      newTags = _.clone(@props.value or [])
      newTags.push(item)
      @props.onChange(newTags)

  render: ->
    self = @
    (div {id: @props.id, className: "tagged-input #{@props.className}", onClick: @focusToInput}, [
      (ul {}, [
        # Existing events
        (@props.value or []).map (tag, i) ->
          (TagItem {item: tag, index: i, removeTagHandler: self.onRemoveTag}) if tag

        # Input with tag separation support
        (InputItem {
          ref: 'tagInput',
          removeLastTagHandler: @onRemoveLastTag,
          addTagHandler: @onAddTag,
          placeholder: (@props.placeholder if not @props.value)
          allowSpace: @props.allowSpace
          allowComma: @props.allowComma
          suggestions: @props.suggestions
        })
      ])
    ])