React = require 'react'
{span, div, section} = React.DOM
{footer, header} = require 'components', 'footer', 'header'

module.exports = React.createClass
  propTypes:
    route: React.PropTypes.string.isRequired
    params: React.PropTypes.object.isRequired

  render: ->
    (div {id: "application"}, [
      (header {path: @props.route, route: @props.params})
      (section {},
        (require("components/#{@props.route}/index") {route: @props.params})
      )
      (footer {path: @props.route, route: @props.params})
    ])