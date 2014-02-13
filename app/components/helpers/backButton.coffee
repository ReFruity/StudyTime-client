React = require 'react'
{span, i, a} = React.DOM

module.exports = React.createClass
  getDefaultProps: ->
    text: t('buttons.back')

  back: ->
    window.location = window.location.href.match(/(.*)\//)[1]

  render: ->
    a {className: 'back-btn', onClick: @back}, [
      i {className: 'stico-arrow-right rotate-180'}
      span {}, @props.text
    ]
