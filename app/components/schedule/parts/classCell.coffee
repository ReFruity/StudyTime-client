{span, div, a} = React.DOM
{classSet} = React.addons
router = require 'router'

##
# Component for showing shortest info about class
# in schedule. Can open/hide details by moving to another
# URL
# Exports the function with one parameter `baseUrl` for
# right routing in different use places
#
module.exports = (baseUrl)->
  React.createClass
    propTypes:
      data: React.PropTypes.array
      date: React.PropTypes.object
      dow: React.PropTypes.string
      number: React.PropTypes.string

    render: ->
      {dow, number, data} = @props
      (div {className: 'class-cell'}, (
        if data
          route = router.getParams()
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