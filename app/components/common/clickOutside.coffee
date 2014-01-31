##
# This mixin component detects click outside the component DOM elemtn
# and invoke `this.onClickOutside` method
#

elementsList = []
if window
  $ = require 'traversty'
  Gator = require('gator')
  Gator(window.document).on('click', (evt) ->
    for e in elementsList when e
      target = $(evt.target)
      if not target.closest(e[0]).length and (not e[1].excludeClickOutside or not target.closest(e[1].excludeClickOutside).length )
        e[1].onClickOutside()
  )

module.exports = {
  componentDidMount: (element) ->
    self = @
    setTimeout(->
      self.__clickOutsideIndex = elementsList.push([element, self]) - 1
    , 10)

  componentWillUnmount: ->
    elementsList[@__clickOutsideIndex] = undefined
}