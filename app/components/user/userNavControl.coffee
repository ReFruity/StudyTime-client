React = require 'react'
{span, div, ul, li, nav, a, i} = React.DOM
{i18n, authorized, currentUserMixin} = require '/components/common', 'authorized', 'currentUserMixin'
{classSet} = React.addons

module.exports = React.createClass
  mixins: [currentUserMixin]

  onUserUpdate: ->
    @forceUpdate()

  render: ->
    if not @isUserAuthorized()
      authorized {},
        span {}, t('layouts.main.login')
    else
      span {'ava'}