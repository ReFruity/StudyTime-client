{span, div, a} = React.DOM
{classSet} = React.addons
router = require 'router'

##
# Component for showing info about event in a row
#
module.exports = (baseUrl, editor, switchEditorHandler)->
  React.createClass
    render: ->
      (span {}, 'event row')