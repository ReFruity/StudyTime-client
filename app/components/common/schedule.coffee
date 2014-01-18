{span, div, ul, li, nav, a, i} = React.DOM
{classSet} = React.addons

module.exports =
  # Schedule grid
  grid: React.createClass
    render: ->
      (div {}, [])

  # Grid rendered row by row for effective details showing
  _row: React.createClass
    render: ->
      (div {}, [])

  # Grid must contains list of cells with coordinates
  cell: React.createClass
    propTypes:
      dow: React.PropTypes.string.isRequired
      class: React.PropTypes.number.isRequired

    render: ->
      (div {}, [])