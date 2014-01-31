React = require 'react'
{div, span} = React.DOM

##
# The same that creator but provides posibility
# of selection any event in schedule for auto fill
# the form. On submit it changes selected event.
#
module.exports = React.createClass
  getInitialState: ->
    event: {}

  render: ->
    (div {className: 'ch-event'}, [
      (span {}, 'test')
    ])