React = require 'react'
{span, div, ul, li, a, i, nav} = React.DOM
{clickOutside, i18n} = require '/components/common', 'clickOutside', 'i18n'
{classInfo, classAttachments} = require '/components/schedule/parts', 'classInfo', 'classAttachments'
{classSet} = React.addons

##
# Abstract component for showing list of events
#
module.exports = (baseUrl, closeUrl) ->
  React.createClass
    propTypes:
      rowElem: React.PropTypes.func.isRequired,
      detailsElem: React.PropTypes.func,
      separateBy: React.PropTypes.oneOf ['type']
      events: React.PropTypes.object
      details: (propValue, propName) ->
        details = propValue[propName]
        if details and (not details.inxed or not details.data)
          throw new Error('Mallformed details prop. Must contain `index` and `data` fields')

    render: ->
      (span {}, 'events list')