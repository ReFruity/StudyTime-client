React = require 'react'
{span, i, a} = React.DOM

module.exports = React.createClass
  getDefaultProps: ->
    text: t('buttons.back')

  getBackHref: ->
    match = window.location.href.match(/\/\/[^\/]+\/(.*)\//)
    if match then '/'+match[1] else '/'

  render: ->
    a {className: 'back-btn', onClick: @back, href: @getBackHref()}, [
      i {className: 'stico-arrow-right rotate-180'}
      span {}, @props.text
    ]
