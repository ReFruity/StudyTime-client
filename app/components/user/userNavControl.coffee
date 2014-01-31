React = require 'react'
{span, div, ul, li, nav, a, i} = React.DOM
{classSet} = React.addons

module.exports = React.createClass
  render: ->
    (span {}, ['Вход'])