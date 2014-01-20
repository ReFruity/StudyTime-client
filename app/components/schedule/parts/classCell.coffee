{span, div} = React.DOM
{a} = requireComponents('/common', 'a')
{classSet} = React.addons
router = require 'router'

##
# Component for showing shortest info about class
# in schedule. Can open/hide details by moving to another
# URL
#
module.exports = React.createClass
  propTypes:
    data: React.PropTypes.array
    date: React.PropTypes.object
    dow: React.PropTypes.string
    number: React.PropTypes.string

  render: ->
    {dow, number, data} = @props
    (div {className: 'class-cell'}, (
      if data
        route = router.getRouteParams()
        data.map (atom, i)->
          href = (if route.dow == dow and route.number == number and route.atom == i + "" then ':group' else ":group/#{dow}/#{number}/#{i}")
          (a {href: href, className: "cell-atom parity-#{atom.parity} hg-#{atom.half_group}"},
            [
              (span {className: 'atom-name'}, atom.subject.name)
              (div {className: 'atom-places'}, (atom.place or []).map (place) ->
                (span {}, place.name)
              )
            ])
    ))