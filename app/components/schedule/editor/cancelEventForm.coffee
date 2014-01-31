React = require 'react'
{span} = React.DOM

##
# Provides functionality for canceling events
# On submit it cancels selected in schedule event
#
module.exports = React.createClass
  propTypes:
    date: React.PropTypes.object
    event: React.PropTypes.object

  getInitialState: ->
    event: {}

  render: ->
    (span {}, 'cancel')