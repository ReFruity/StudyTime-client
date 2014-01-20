{span, div, a} = React.DOM
{classSet} = React.addons
router = require 'router'

##
# Component for showing shortest info about class
# in schedule. Can open/hide details by moving to another
# URL
# Exports the function with first parameter `baseUrl` for
# right routing in different use places
# Second and third parameters used for creating editable
# friendly schedule. Depending on given `mode` it handles
# clicks on thw whole cell or part of cell for pushing to
# editor some useful information (cell coordinates, event id, etc.)
#
module.exports = (baseUrl, editor, switchEditorHandler)->
  React.createClass
    propTypes:
      data: React.PropTypes.array
      date: React.PropTypes.object
      dow: React.PropTypes.string
      number: React.PropTypes.string

    getDefaultProps: ->
      route: router.getParams()

    render: ->
      {dow, number, data, route} = @props
      (div {className: 'class-cell'}, (
        if data
          data.map (atom, i)->
            href = (if route.dow == dow and route.number == number and route.atom == i + "" then baseUrl else "#{baseUrl}/#{dow}-#{number}-#{i}")
            (a {href: href, className: "cell-atom parity-#{atom.parity} hg-#{atom.half_group}"},
              [
                (span {className: 'atom-name'}, atom.subject.name)
                (div {className: 'atom-places'}, (atom.place or []).map (place) ->
                  (span {}, place.name)
                )
              ])
      ))