{span, div, section} = React.DOM
{footer, header} = requireComponents('/', 'footer', 'header')

module.exports = React.createClass
  propTypes:
    route: React.PropTypes.string.isRequired
    params: React.PropTypes.object.isRequired

  render: ->
    (div {}, [
      (header {path: @props.route})
      (section {},
        (requireComponent(@props.route) {route: @props.params})
      )
      (footer {})
    ])