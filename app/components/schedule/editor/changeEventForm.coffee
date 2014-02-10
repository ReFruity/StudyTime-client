React = require 'react'
{div, span} = React.DOM
{createEventForm} = require '/components/schedule/editor', 'createEventForm'

##
# The same that creator but provides posibility
# of selection any event in schedule for auto fill
# the form. On submit it changes selected event.
#
module.exports = createEventForm