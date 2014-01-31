React = require 'react'
{span, div, a} = React.DOM
{classSet} = React.addons

##
# Component for showing info about event in a row
#
module.exports = (baseUrl, editor, switchEditorHandler)->
  React.createClass
    render: ->
      (span {}, 'event row')