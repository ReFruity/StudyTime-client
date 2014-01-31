React = require 'react'
{span, div, ul, li, a, i, nav} = React.DOM
{clickOutside, i18n} = require '/components/common', 'clickOutside', 'i18n'
{classInfo, classAttachments} = require '/components/schedule/parts', 'classInfo', 'classAttachments'
{classSet} = React.addons
router = require 'router'

##
# Component for showing details about exam/test event
# Contains timer to start the event and attachments to the subject
# of event
#
module.exports = (baseUrl, closeUrl) ->
  React.createClass
    mixins: [clickOutside]

    propTypes:
      data: React.PropTypes.object.isRequired

    render: ->
      (span {}, 'events details')