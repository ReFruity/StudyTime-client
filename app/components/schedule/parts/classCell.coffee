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
module.exports = React.createClass
  propTypes:
    data: React.PropTypes.array
    date: React.PropTypes.object
    dow: React.PropTypes.string
    number: React.PropTypes.string
    baseUrl: React.PropTypes.string.isRequired
    bounds: React.PropTypes.array.isRequired
    editor: React.PropTypes.object.isRequired
    switchEditorHandler: React.PropTypes.func.isRequired
    route: React.PropTypes.object.isRequired

  getCellUniqueId: (p)->
    """
      #{not p.route.dow or not p.route.number or p.route.dow != p.dow or p.route.number != p.number}
      #{((p.data or []).map (a)-> a.subject.name+((a.place or []).map (p)->p.name).join('.')+a.parity+a.half_group+a.type).join('.')}
      #{p.bounds[0].getTime()}.#{p.bounds[1].getTime()}
      #{p.editor.mode}
      #{p.route.atom if p.route.dow == p.dow and p.route.number == p.number}
    """

  shouldComponentUpdate: (newProps)->
    @getCellUniqueId(@props) != @getCellUniqueId(newProps)

  render: ->
    {dow, number, data, route, baseUrl, editor, bounds, switchEditorHandler} = @props
    (div {className: 'class-cell'}, (
      if data
        # Filter schedule not in given bounds
        data.filter (atom) ->
          act =
            start: new Date(atom.activity.start)
            end: new Date(atom.activity.end)

          if act.start <= bounds[0] < act.end or act.start < bounds[1] <= act.end or (bounds[0] <= act.start and bounds[1] >= act.end)
            yes
          else
            no

        # Show each filtered atom
        .map (atom, i) ->
            # Get link
            href = (if route.dow == dow and route.number == number and route.atom == i + "" then baseUrl else "#{baseUrl}/#{dow}-#{number}-#{i}")

            # Get cut places
            if atom.place and atom.place.length > 3
              places = atom.place.slice(0, 3)
              places.push(name: '...')
            else
              places = atom.place

            # Render
            (a {href: href, className: "cell-atom parity-#{atom.parity} hg-#{atom.half_group}"},
              [
                (span {className: 'atom-name'}, atom.subject.name)
                (div {className: 'atom-places'}, (places or []).map (place) ->
                  (span {}, place.name)
                )
              ])
    ))