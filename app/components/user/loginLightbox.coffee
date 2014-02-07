React = require 'react'
{span, div, ul, li, nav, a, i} = React.DOM
{i18n, authorized, currentUserMixin} = require '/components/common', 'authorized', 'currentUserMixin'
{classSet} = React.addons

module.exports = React.createClass
  onClose: ->
    @props.onClose()

  render: ->
    div {}, 'test dg sfdg hsfd lsfdlgh lsfdh lskfdhg lkshf lghsl lsfdhk '