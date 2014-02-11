React = require 'react'
config = require 'config/config'
{span, div, ul, li, nav, a, i, h2,h3, p} = React.DOM
{i18n, authorized, currentUserMixin} = require '/components/common', 'authorized', 'currentUserMixin'
{classSet} = React.addons

module.exports = React.createClass
  mixins: [currentUserMixin]

  propTypes:
    onClose: React.PropTypes.func.isRequired
    withContinue: React.PropTypes.boolean

  getDefaultProps: ->
    reason: ''

  onClose: ->
    @props.onClose()

  onUserUpdate: ->
    if @isUserAuthorized()
      @props.onClose()

  loginFacebook: ->
    document.domain = config.domain
    wnd = window.open(config.fbAuthUrl, 'VK Auth', 'height=400,width=600')
    if window.focus then wnd.focus()

  loginVk: ->
    document.domain = config.domain
    wnd = window.open(config.vkAuthUrl, 'VK Auth', 'height=400,width=600')
    if window.focus then wnd.focus()

  render: ->
    div {className: 'login-lightbox'},
      h2 {}, 'Войдите'+@props.reason
      p {}, 'с помощью аккаунта в одной из социальных сетей'
      div {className: 'row'},
        a {className: 'col-xs-6 text-right'},
          span {}, 'ВКонтакте'
          div {onClick: @loginVk, className: 'vk sbtn'},
            i {className: 'stico-vk'}
        a {className: 'col-xs-6 text-left'},
          div {onClick: @loginFacebook, className: 'fb sbtn'},
            i {className: 'stico-fb'}
          span {}, 'Facebook'