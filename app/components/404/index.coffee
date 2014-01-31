React = require 'react'
{span} = React.DOM

module.exports = React.createClass
  render: ->
    (span {}, ['Not found!'])