React = require 'react'
{span, div, ul, li, nav, a, i} = React.DOM
{i18n, authorized, currentUserMixin, photo} = require '/components/common', 'authorized', 'currentUserMixin', 'photo'
{classSet} = React.addons

module.exports = React.createClass
  mixins: [currentUserMixin]

  onUserUpdate: ->
    @forceUpdate()

  render: ->
    if not @isUserAuthorized()
      div {className: 'login-wrap'},
        authorized {},
          span {}, t('layouts.main.login')
    else
      div {className: 'ava-wrap'},
        photo {size: 'small', id: @getCurrentUser()._id, format: 'jpg'}