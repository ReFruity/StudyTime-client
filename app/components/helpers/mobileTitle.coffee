React = require 'react'
{div} = React.DOM
BackButton = require '/components/helpers/backButton'

module.exports = React.createClass
  propTypes:
    title: React.PropTypes.string.isRequired

  render: ->
    div {className: 'mobile-title'}, [
      BackButton()
      div {className: 'title'}, @props.title
    ]